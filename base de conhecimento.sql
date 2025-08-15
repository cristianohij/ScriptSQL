select * from ModelCrossReference (nolock)

select * from ModelEntityProperty (nolock) where ModelEntityPropertyValue='Main Programs'

select EntityId,count(*) as 'conta' from ModelEntityProperty (nolock) group by EntityId order by conta desc