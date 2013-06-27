<Query Kind="Statements">
  <Output>DataGrids</Output>
  <NuGetReference>morelinq</NuGetReference>
  <Namespace>MoreLinq</Namespace>
  <Namespace>System.IO.Compression</Namespace>
</Query>

//var binPath = @"C:\Users\james\Documents\LINQPad.assemblies.DotNetLanguage.bin";
var binPath = @"C:\Users\james\Documents\LINQPad.assemblies.ActiproSoftware.Shared.Net20.bin";
var dllPath = Path.ChangeExtension(binPath, ".dll");

using (var fileStream = File.OpenRead(binPath))
using (DeflateStream deflateStream = new DeflateStream(fileStream, CompressionMode.Decompress))
{
	var content = new System.IO.BinaryReader(deflateStream).ReadBytes(2000000);
    File.WriteAllBytes(dllPath, content);
}
