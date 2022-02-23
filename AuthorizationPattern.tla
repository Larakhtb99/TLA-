------------------------ MODULE AuthorizationPattern ------------------------
VARIABLES user1, user2 , authorizer,Entity1, Entity2

\* user
id1 == 1
id2 == 2

EntityId1 == 1
EntityId2 == 2

\*authorizer
idini == 1

init == /\ authorizer = [id |-> idini] 
        /\ Entity1 = [id |-> EntityId1]
        /\ Entity2 = [id |-> EntityId2]
        /\ user1 = [id |-> id1, authorizer |-> authorizer["id"], EntityId |-> {Entity1["id"],Entity2["id"]} ]
        /\ user2 = [id |-> id2, authorizer |-> authorizer["id"], EntityId |-> Entity1["id"] ]

TypeOk == /\ user1["id"] = id1 \* P1: user.id = id1 (initial)
          /\ user2["id"] = id2 
          /\ user1["id"] # user2["id"] \* P2: user1.id # user2.id  
          /\ authorizer["id"] = idini \* P3: authorizer.id = id initial
          /\ user1["authorizer"] = authorizer["id"] \* or idini  P4 : user1.authorizer = user1.authorizerini
          /\ user2 ["authorizer"] = authorizer["id"] 
          /\ Entity1["id"] = EntityId1  \* P5: Entity.id = Entity.idini
          /\ Entity2["id"] = EntityId2
          /\ Entity1["id"] # Entity2["id"] \*P6: Entity1.id # Entity2.id
          /\ user1["EntityId"] =  {Entity1["id"],Entity2["id"]}  \* P7: user1.EntityId = user1.EntityIdini 
          /\ user2["EntityId"] =  Entity1["id"]      
          
next ==  \*/\ user1' = [id |-> 3, authorizer |-> authorizer["id"], EntityId |-> {EntityId1,EntityId2}] \* verifier P1
         \*/\ user1' = [id |-> id2, authorizer |-> authorizer["id"], EntityId |-> {EntityId1,EntityId2}] \* verifier P2
         \*/\ authorizer' = [id |-> 3]  \*verifier P3
         \*/\ user1' = [id |-> id1, authorizer |-> 2,EntityId |-> {Entity1["id"],Entity2["id"]}] \* verifier P4
         \*/\ Entity1'  = [id |-> 3] \*verifier P5
         \*/\ Entity1' = [id |-> Entity2["id"] ] \* verifier P6
         \*/\ user2' = [id |-> id2, authorizer |-> authorizer["id"], EntityId |-> {EntityId1,EntityId2} ] \*verifier P7
         /\ UNCHANGED <<user1,user2,authorizer,Entity1,Entity2>>


=============================================================================
\* Modification History
\* Last modified Thu Feb 17 23:38:00 CET 2022 by Lara
\* Created Thu Feb 17 14:53:11 CET 2022 by Lara
