<Query Kind="Statements">
  <Connection>
    <ID>4995e2a3-152c-43e7-bb14-da49a48a25b1</ID>
    <Persist>true</Persist>
    <Server>3bhs001</Server>
    <Database>Assessment</Database>
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
  <Namespace>MoreLinq</Namespace>
  <Namespace>System.Net</Namespace>
  <Namespace>System.Web</Namespace>
</Query>

var constraintDropsQuery = @"
    select
        'ALTER TABLE [' + s.name + '].[' + p.name + '] DROP CONSTRAINT [' + o.name + ']'
    from
        sys.objects o
            inner join sys.objects p
                on o.parent_object_id = p.object_id
            inner join sys.schemas s
                on p.schema_id = s.schema_id
    where
        o.type_desc = 'DEFAULT_CONSTRAINT'
";

var constraintDrops = this.ExecuteQuery<string>(constraintDropsQuery).ToArray();
constraintDrops.Dump();
return;

foreach (var alterStatement in constraintDrops)
{
    try
    {	        
        this.ExecuteCommand(alterStatement);
//        alterStatement.Dump(column.ColumnType);
    }
    catch (Exception ex)
    {
        Console.WriteLine ("Failed to execute {0}: {1}", alterStatement, ex);
        // just ignore
    }
}