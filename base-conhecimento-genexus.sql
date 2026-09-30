-- base de conhecimento genexus

SELECT 
    o.ObjId,
    o.ObjName,
    c.ObjClsName AS ObjectType
FROM OBJECT o
JOIN OBJ_CLSS c ON o.ObjClsId = c.ObjClsId
ORDER BY o.ObjName;

SELECT o.*
FROM OBJECT o
JOIN OBJ_CLSS c ON o.model_id = c.model_id
ORDER BY o.obj_name;

select *
  from OBJ_CLSS

SELECT AttributeId, AttributeName
FROM ATTRIBUTE
ORDER BY AttributeName;


-- descubra os nomes reais das colunas

-- Ver colunas da tabela OBJECT
EXEC sp_help 'dbo.[OBJECT]';

-- ou
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'OBJECT';

-- idem para ATTRIBUTE e TABLES
SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'ATTRIBUTE';

SELECT COLUMN_NAME
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'TABLES';

SELECT TOP (1) 'ATTRIBUTE',* FROM dbo.ATTRIBUTE;
SELECT TOP (1) 'CK',* FROM dbo.CK;
SELECT TOP (1) 'CK_ATRI',* FROM dbo.CK_ATRI;
SELECT TOP (1) 'Entity',* FROM dbo.Entity;
SELECT TOP (1) 'EntityType',* FROM dbo.EntityType;
SELECT TOP (1) 'EntityVersion',* FROM dbo.EntityVersion;
SELECT TOP (1) 'EntityVersionComposition',* FROM dbo.EntityVersionComposition;
SELECT TOP (1) 'IDX_ATRI',* FROM dbo.IDX_ATRI;
SELECT TOP (1) 'INDEX',* FROM dbo.[INDEX];
SELECT TOP (1) 'KnowledgeBaseInformation',* FROM dbo.KnowledgeBaseInformation;
SELECT TOP (1) 'MODEL',* FROM dbo.MODEL;
SELECT TOP (1) 'ModelCrossReference',* FROM dbo.ModelCrossReference;
SELECT TOP (1) 'ModelEntityHistory',* FROM dbo.ModelEntityHistory;
SELECT TOP (1) 'ModelEntityOutput',* FROM dbo.ModelEntityOutput;
SELECT TOP (1) 'ModelEntityProperty',* FROM dbo.ModelEntityProperty;
SELECT TOP (1) 'ModelEntityToTable',* FROM dbo.ModelEntityToTable;
SELECT TOP (1) 'ModelEntityVersion',* FROM dbo.ModelEntityVersion;
SELECT TOP (1) 'OBJ_CLSS',* FROM dbo.OBJ_CLSS;
SELECT TOP (1) 'OBJ_INFO',* FROM dbo.OBJ_INFO;
SELECT TOP (1) 'OBJ_UPD',* FROM dbo.OBJ_UPD;
SELECT TOP (1) 'OBJECT',* FROM dbo.[OBJECT];
SELECT TOP (1) 'State',* FROM dbo.[State];
SELECT TOP (1) 'TABLES',* FROM dbo.TABLES;
SELECT TOP (1) 'TBL_ATRI',* FROM dbo.TBL_ATRI;
SELECT TOP (1) 'TRN_DSD',* FROM dbo.TRN_DSD;
SELECT TOP (1) 'UdmModel',* FROM dbo.UdmModel;
SELECT TOP (1) 'VIEW_KEY',* FROM dbo.VIEW_KEY;

SELECT * FROM dbo.ATTRIBUTE;
SELECT * FROM dbo.CK;
SELECT * FROM dbo.CK_ATRI;
SELECT * FROM dbo.Entity;

-- transações

select *
  from [OBJECT] obj with (nolock)
-- inner join OBJ_CLSS o_class with (nolock)
--         on o_class.obj_class = obj.obj_class
 inner join OBJ_INFO obj_info with (nolock)
         on obj_info.obj_class = obj.obj_class
            and obj_info.obj_id = obj.obj_id
 inner join OBJ_UPD obj_update with (nolock)
         on obj_update.obj_class = obj.obj_class
            and obj_update.obj_id = obj.obj_id
 inner join dbo.TABLES tab with (nolock)
         on tab.table_id = obj.obj_id
 where obj.obj_name = 'TTBS002'   

SELECT TOP (1) 'ATTRIBUTE',* FROM dbo.ATTRIBUTE;
--SELECT TOP (1) 'CK',* FROM dbo.CK;
--SELECT TOP (1) 'CK_ATRI',* FROM dbo.CK_ATRI;
--SELECT TOP (1) 'Entity',* FROM dbo.Entity;
SELECT TOP (1) 'TABLES',* FROM dbo.TABLES;
SELECT TOP (1) 'TBL_ATRI',* FROM dbo.TBL_ATRI;
SELECT TOP (1) 'TRN_DSD',* FROM dbo.TRN_DSD;

select *
  from dbo.ATTRIBUTE att with (nolock)
 inner join CK_ATRI cka with (nolock)
         on cka.model_id = att.model_id
            and cka.CKAattri_num = att.attri_num
 inner join dbo.TABLES tab with (nolock)
         on tab.table_id = cka.table_id
 inner join dbo.CK ck with (nolock)
         on ck.model_id = cka.model_id
            and ck.ck_num = cka.ck_num
 where att.model_id = 1
       and attri_name = 'CLICOD'

select *
  from [TABLES] tab with (nolock)
 inner join CK_ATRI cka with (nolock)
         on cka.table_id = tab.table_id
 inner join ATTRIBUTE att with (nolock)
         on att.attri_num = cka.CKAattri_num

select *
  from [TABLES] tab with (nolock)
 inner join [OBJECT] obj with (nolock)
         on obj.obj_id = tab.table_id
 --inner join OBJ_INFO obj_info with (nolock)
         --on obj_info.obj_class = tab. obj.obj_class
            --and obj_info.obj_id = obj.obj_id  
 inner join TBL_ATRI tab_atri with (nolock)
         on tab_atri.table_id = tab.table_id
 inner join ATTRIBUTE att with (nolock)
         on att.attri_num = tab_atri.TBAattri_num

select *
  from [TABLES] tab with (nolock)
 inner join [OBJECT] obj with (nolock)
         on obj.model_id = tab.model_id
            and obj.obj_id = tab.table_id  
 inner join CK_ATRI atri with (nolock)
         on atri.model_id = tab.model_id
            and atri.table_id = tab.table_id
 inner join ATTRIBUTE att with (nolock)
         on att.model_id = tab.model_id att.attri_num =  atri.CKAattri_num
 where tab.model_id = 1

select *
  from [TABLES] tab with (nolock)
 inner join CK_ATRI cka with (nolock)
         on cka.model_id = tab.model_id
            and cka.table_id = tab.table_id  
 where tab.model_id = 1

select *
  from UdmModel with (nolock)

select count(*)
  from [TABLES] tab with (nolock)
 where tab.model_id = 1

select tab.table_id
  from [TABLES] tab with (nolock)
 where tab.model_id = 1
 group by tab.table_id
 order by tab.table_id

select obj.obj_name
       ,obj.obj_title
       ,tab.*
       ,' --- '
       ,obj.*
  from [TABLES] tab with (nolock)
 inner join [OBJECT] obj with (nolock)
         on obj.model_id = tab.model_id
            and obj.obj_id = tab.table_id         
 where tab.model_id = 1

select *
  from ATTRIBUTE att with (nolock)

