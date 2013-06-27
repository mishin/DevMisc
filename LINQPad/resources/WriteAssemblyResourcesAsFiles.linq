<Query Kind="Statements">
  <Output>DataGrids</Output>
  <NuGetReference>morelinq</NuGetReference>
  <Namespace>MoreLinq</Namespace>
  <Namespace>System.IO.Compression</Namespace>
</Query>

var baseDir = @"C:\Users\james\Documents\lpres";
var assembly = typeof(LINQPad.Util).Assembly;
var resNames = assembly.GetManifestResourceNames();
foreach (var resName in resNames)
{
    var stream = assembly.GetManifestResourceStream(resName);
    var content = new System.IO.BinaryReader(stream).ReadBytes(2000000);
    var filePath = Path.Combine(baseDir, resName);
    File.WriteAllBytes(filePath, content);
    if (filePath.EndsWith(".bin"))
    {
        using (var fileStream = File.OpenRead(filePath))
        using (DeflateStream deflateStream = new DeflateStream(fileStream, CompressionMode.Decompress))
        {
            content = new System.IO.BinaryReader(deflateStream).ReadBytes(2000000);
            var dllPath = Path.ChangeExtension(filePath, ".dll");
            File.WriteAllBytes(dllPath, content);
        }
    }
}