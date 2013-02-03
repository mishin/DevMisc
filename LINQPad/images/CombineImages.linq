<Query Kind="Statements">
  <Output>DataGrids</Output>
  <Reference>&lt;RuntimeDirectory&gt;\Accessibility.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\Microsoft.Build.Framework.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\Microsoft.Build.Tasks.v4.0.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\Microsoft.Build.Utilities.v4.0.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.ComponentModel.DataAnnotations.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Configuration.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Deployment.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Design.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.DirectoryServices.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.DirectoryServices.Protocols.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.EnterpriseServices.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\wpf\System.Printing.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Runtime.Caching.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Security.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.ServiceProcess.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Web.ApplicationServices.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Web.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Web.RegularExpressions.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Web.Services.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Windows.Forms.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Xaml.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\wpf\UIAutomationProvider.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\wpf\UIAutomationTypes.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\wpf\WindowsBase.dll</Reference>
  <NuGetReference Prerelease="true">morelinq</NuGetReference>
  <Namespace>MoreLinq</Namespace>
  <Namespace>System.Drawing</Namespace>
  <Namespace>System.Net</Namespace>
  <Namespace>System.Web</Namespace>
  <Namespace>System.Windows.Forms</Namespace>
</Query>

var monitorCount = 3;
var imageFilterDeclaration = "Image Files|*.jpg;*.jpeg;*.png;*.bmp;*.gif;*.ico;*.wdp;*.tiff";

var filePaths = new string[monitorCount];

for (int i = 0; i < filePaths.Length; i++)
{
    var fileDialog = new OpenFileDialog()
    {
        Title = String.Format("Choose file #{0}", i+1),
        CheckFileExists = true,
        Multiselect = false,
        Filter = imageFilterDeclaration,
    };
    var dialogResult = fileDialog.ShowDialog();
    if (dialogResult != DialogResult.OK)
    {
        return;
    }
    
    filePaths[i] = fileDialog.FileName;
}

var images = filePaths
    .Select(x => new Bitmap(x))
    .ToArray();

if (images.All(x => x.Height == images[0].Height) == false)
{
    throw new InvalidOperationException("all images must have the same height");
}

if (images.All(x => x.Width == images[0].Width) == false)
{
    throw new InvalidOperationException("all images must have the same width");
}

var outputHeight = images[0].Height;
var outputWidth = images.Sum(x => x.Width);

var outputImage = new Bitmap(outputWidth, outputHeight);

using (var g = Graphics.FromImage(outputImage))
{
    //set background color
    g.Clear(System.Drawing.Color.Black);

    //go through each image and draw it on the output image
    int offset = 0;
    foreach (System.Drawing.Bitmap image in images)
    {
        g.DrawImage(image,
            new System.Drawing.Rectangle(offset, 0, image.Width, image.Height)
        );
        offset += image.Width;
    }
}

var saveFileDialog = new SaveFileDialog()
{
    Filter = imageFilterDeclaration,
};
if (saveFileDialog.ShowDialog() == DialogResult.OK)
{
    outputImage.Save(saveFileDialog.FileName);
    Console.WriteLine("Saved file {0}", saveFileDialog.FileName);
}