select * from TBS031 A (noLock) join JAGUAR.SIBD.dbo.TBS031 B (noLock) on A.TDPPROCOD=B.TDPPROCOD
 where str(A.TDPPRELOJ1,9,2)<>str(B.TDPPRELOJ1,9,2)