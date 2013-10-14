<Query Kind="Expression">
  <Connection>
    <ID>bc340f9f-ec80-42c8-96a2-14179b037eba</ID>
    <Persist>true</Persist>
    <Server>3bhs001</Server>
    <Database>ClientDB</Database>
    <ShowServer>true</ShowServer>
  </Connection>
  <Reference>&lt;RuntimeDirectory&gt;\Microsoft.Build.Framework.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\Microsoft.Build.Tasks.v4.0.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\Microsoft.Build.Utilities.v4.0.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.ComponentModel.DataAnnotations.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Configuration.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Design.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.DirectoryServices.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.DirectoryServices.Protocols.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.EnterpriseServices.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Runtime.Caching.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Security.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.ServiceProcess.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Web.ApplicationServices.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Web.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Web.RegularExpressions.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Web.Services.dll</Reference>
  <Reference>&lt;RuntimeDirectory&gt;\System.Windows.Forms.dll</Reference>
  <NuGetReference>morelinq</NuGetReference>
  <Namespace>MoreLinq</Namespace>
  <Namespace>System.Net</Namespace>
  <Namespace>System.Web</Namespace>
</Query>

from metaTable in this.Mapping.GetTables()
where metaTable.TableName != "[sysdiagrams]" // ignore SSMS diagrams table

from metaDataMember in metaTable.RowType.DataMembers
where metaDataMember.DbType != null // only view actual columns

where metaDataMember.MappedName.ToLower().Contains("cme")

select new
{
    TableName = metaTable.TableName,
    ColumnName = metaDataMember.MappedName,
    ColumnType = metaDataMember.DbType,
}
