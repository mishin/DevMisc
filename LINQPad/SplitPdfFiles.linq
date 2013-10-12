<Query Kind="Statements">
  <Output>DataGrids</Output>
  <NuGetReference>Google.GData.YouTube</NuGetReference>
  <NuGetReference>morelinq</NuGetReference>
  <NuGetReference>Newtonsoft.Json</NuGetReference>
  <NuGetReference>PdfSharp</NuGetReference>
  <Namespace>Google.GData.Client</Namespace>
  <Namespace>Google.GData.Client.ResumableUpload</Namespace>
  <Namespace>Google.GData.Extensions</Namespace>
  <Namespace>Google.GData.Extensions.AppControl</Namespace>
  <Namespace>Google.GData.Extensions.Apps</Namespace>
  <Namespace>Google.GData.Extensions.Exif</Namespace>
  <Namespace>Google.GData.Extensions.Location</Namespace>
  <Namespace>Google.GData.Extensions.MediaRss</Namespace>
  <Namespace>Google.GData.YouTube</Namespace>
  <Namespace>Google.YouTube</Namespace>
  <Namespace>MoreLinq</Namespace>
  <Namespace>Newtonsoft.Json</Namespace>
  <Namespace>Newtonsoft.Json.Bson</Namespace>
  <Namespace>Newtonsoft.Json.Converters</Namespace>
  <Namespace>Newtonsoft.Json.Linq</Namespace>
  <Namespace>Newtonsoft.Json.Schema</Namespace>
  <Namespace>Newtonsoft.Json.Serialization</Namespace>
  <Namespace>PdfSharp</Namespace>
  <Namespace>PdfSharp.Charting</Namespace>
  <Namespace>PdfSharp.Drawing</Namespace>
  <Namespace>PdfSharp.Drawing.BarCodes</Namespace>
  <Namespace>PdfSharp.Drawing.Layout</Namespace>
  <Namespace>PdfSharp.Fonts</Namespace>
  <Namespace>PdfSharp.Fonts.OpenType</Namespace>
  <Namespace>PdfSharp.Forms</Namespace>
  <Namespace>PdfSharp.Pdf</Namespace>
  <Namespace>PdfSharp.Pdf.AcroForms</Namespace>
  <Namespace>PdfSharp.Pdf.Actions</Namespace>
  <Namespace>PdfSharp.Pdf.Advanced</Namespace>
  <Namespace>PdfSharp.Pdf.Annotations</Namespace>
  <Namespace>PdfSharp.Pdf.Content</Namespace>
  <Namespace>PdfSharp.Pdf.Content.Objects</Namespace>
  <Namespace>PdfSharp.Pdf.Filters</Namespace>
  <Namespace>PdfSharp.Pdf.IO</Namespace>
  <Namespace>PdfSharp.Pdf.Printing</Namespace>
  <Namespace>PdfSharp.Pdf.Security</Namespace>
</Query>

// populate with whatever set of files should be considered for split
var sourceFilePaths = Directory.GetFiles(@"C:\Users\james\Desktop\taxes-2012-scans", "*.pdf");

foreach (var sourceFilePath in sourceFilePaths)
{
    // Open the file
    PdfDocument inputDocument = PdfReader.Open(sourceFilePath, PdfDocumentOpenMode.Import);
    
    if (inputDocument.PageCount < 2)
    {
        // only split pdf files that have multiple pages
        continue;
    }
    Console.WriteLine ("Splitting {0}", sourceFilePath);

    string name = Path.GetFileNameWithoutExtension(sourceFilePath);
    string outputDir = Path.GetDirectoryName(sourceFilePath);
    for (int idx = 0; idx < inputDocument.PageCount; idx++)
    {
        var outputFilename = String.Format("{0}-page{1}.pdf", name, idx + 1);
        var outputPath = Path.Combine(outputDir, outputFilename);

        // Create new document
        PdfDocument outputDocument = new PdfDocument();
        outputDocument.Version = inputDocument.Version;
        outputDocument.Info.Title =
            String.Format("Page {0} of {1}", idx + 1, inputDocument.Info.Title);
        outputDocument.Info.Creator = inputDocument.Info.Creator;
        
        // Add the page and save it
        outputDocument.AddPage(inputDocument.Pages[idx]);
        Console.WriteLine ("    Writing {0}", outputPath);
        outputDocument.Save(outputPath);
    }
}
