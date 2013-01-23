<Query Kind="Statements">
  <Connection>
    <ID>0bdb7756-7088-4bc7-865f-9b99eb05ecc3</ID>
    <Persist>true</Persist>
    <Server>.</Server>
    <Database>Assessment</Database>
    <ShowServer>true</ShowServer>
  </Connection>
  <Output>DataGrids</Output>
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

var columnInfos =
    from metaTable in this.Mapping.GetTables()
    where metaTable.TableName != "[sysdiagrams]" // ignore SSMS diagrams table
    
    from metaDataMember in metaTable.RowType.DataMembers
    where metaDataMember.DbType != null // only view actual columns
    
    where metaDataMember.MappedName == "CreateDate"
    
    select new
    {
        TableName = metaTable.TableName
                             .Replace("[", String.Empty)
                             .Replace("]", String.Empty),
        ColumnName = metaDataMember.MappedName,
        PrimaryKeyColumns = metaTable.RowType.DataMembers
                                .Where(x => x.IsPrimaryKey)
                                .ToArray(),
    };
//columnInfos.Dump();

foreach (var columnInfo in columnInfos)
{
    var triggerName = String.Format("trg_{0}_{1}", columnInfo.TableName, columnInfo.ColumnName);
    
    if (columnInfo.PrimaryKeyColumns.Length == 0)
    {
        throw new InvalidOperationException("table with no PK: " + columnInfo.TableName);
    }
    
    var whereClauseParts =
        from pkColumn in columnInfo.PrimaryKeyColumns
        select String.Format("{0}.{1} = inserted.{1}", columnInfo.TableName, pkColumn.MappedName);
    var whereClause = String.Join(" AND ", whereClauseParts);
    
    var triggerDropCommand = String.Format(@"
        IF OBJECT_ID ('{0}','TR') IS NOT NULL
            DROP TRIGGER {0}",
        triggerName, 
        columnInfo.TableName,
        columnInfo.ColumnName,
        whereClause);
    this.ExecuteCommand(triggerDropCommand);
    
    var triggerDeclaration = String.Format(@"
        CREATE TRIGGER {0}
        ON {1}
        FOR INSERT AS
        
        UPDATE
            {1}
        SET
            {2} = GetDate()
        FROM
            {1}
                INNER JOIN inserted
                    ON {3}", 
        triggerName, 
        columnInfo.TableName,
        columnInfo.ColumnName,
        whereClause);
    this.ExecuteCommand(triggerDeclaration);
}