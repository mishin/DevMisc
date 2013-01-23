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

var query =
    from metaTable in this.Mapping.GetTables()
    where metaTable.TableName != "[sysdiagrams]" // ignore SSMS diagrams table
    
    from metaDataMember in metaTable.RowType.DataMembers
    where metaDataMember.DbType != null // only view actual columns
    
    where metaDataMember.CanBeNull
    
    select new
    {
        TableName = metaTable.TableName,
        ColumnName = metaDataMember.MappedName,
        ColumnType = metaDataMember.DbType,
    };
//query.Dump();

foreach (var column in query)
{
    var checkQuery = String.Format("select count(*) from {0} where {1} is null", column.TableName, column.ColumnName);
    var nullCount = this.ExecuteQuery<int>(checkQuery).Single();
    if (nullCount != 0)
    {
//        Console.WriteLine("Table={0} Column={1} NullCount={2}", column.TableName, column.ColumnName, nullCount);
    }
    else
    {
        var alterStatement = String.Format("ALTER TABLE {0} ALTER COLUMN {1} {2} NOT NULL", 
                                        column.TableName, 
                                        column.ColumnName, 
                                        column.ColumnType);
                                        
        alterStatement.Dump();
        this.ExecuteCommand(alterStatement);
    }
}
