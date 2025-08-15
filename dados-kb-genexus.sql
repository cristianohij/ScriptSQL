SELECT ev1.EntityVersionName  + ';' + ev2.EntityVersionName 
  FROM ModelCrossReference
          INNER JOIN EntityType AS et1
          INNER JOIN Entity AS e1
          INNER JOIN EntityVersion AS ev1
             ON e1.EntityTypeId = ev1.EntityTypeId AND e1.EntityId = ev1.EntityId AND e1.EntityLastVersionId = ev1.EntityVersionId
             ON et1.EntityTypeId = e1.EntityTypeId
             ON ModelCrossReference.ToEntityTypeId = ev1.EntityTypeId AND ModelCrossReference.ToEntityId = ev1.EntityId
          INNER JOIN EntityType AS et2
          INNER JOIN Entity AS e2
          INNER JOIN EntityVersion AS ev2
             ON e2.EntityTypeId = ev2.EntityTypeId AND e2.EntityId = ev2.EntityId AND e2.EntityLastVersionId = ev2.EntityVersionId
             ON et2.EntityTypeId = e2.EntityTypeId
             ON ModelCrossReference.FromEntityTypeId = ev2.EntityTypeId AND ModelCrossReference.FromEntityId = ev2.EntityId
 WHERE (et2.EntityTypeNamespace = 'Objects')
       AND (et1.EntityTypeNamespace = 'Objects')
       AND (ModelCrossReference.ModelId = 1)