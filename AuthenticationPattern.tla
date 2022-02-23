----------------------------- MODULE AuthenticationPattern -----------------------------
VARIABLES user1, user2 , authenticator

\* user
id1 == 1
id2 == 2

authInfoini1 == "je suis user1" 
authInfoini2 == "je suis user2"

idProof == 0
idProof1 == 1
idProof2 == 2

\*authenticator
idini == 1
authInfo == ""

init == /\ authenticator = [id |-> idini, authInfo |-> authInfo] 
        /\ user1 = [id |-> id1, authInfo |-> authInfoini1 , authenticator |-> authenticator["id"], idProof |-> idProof]
        /\ user2 = [id |-> id2, authInfo |-> authInfoini2,  authenticator |-> authenticator["id"] ,idProof |-> idProof]

TypeOk == /\ user1["id"] = id1 \* P1: user.id = id1 (initial)
          /\ user2["id"] = id2 
          /\ user1["id"] # user2["id"] \* P2: user1.id # user2.id 
          /\ user1["authInfo"] # user2["authInfo"]  \* P3: user1.authInfo # user2. authInfo
          /\ user1["authInfo"] = authInfoini1  \* P4: user1.authInfo = authInfoini1
          /\ user2["authInfo"] = authInfoini2  
          /\ authenticator["id"] = idini \* P5: authenticator.id = id initial
          /\ user1["authenticator"] = authenticator["id"] \* or idini  P6 : user1.authenticator = user1.authenticatorini
          /\ user2 ["authenticator"] = authenticator["id"] \* or idini 
          /\ authenticator["authInfo"] = authInfoini1 \/ authenticator["authInfo"] = authInfoini2 \/ authenticator["authInfo"] = ""  \* P7: authenticator.authInfo = user.authInfo or null
          /\ user1["idProof"] = 0 \/ user1["idProof"] = idProof1 \* P8: user.idProof = null or user.authenticator.request(authInfo)
          /\ user2["idProof"] = 0 \/ user1["idProof"] = idProof2   
          
next ==  \*/\ authenticator' = [id |-> idini, authInfo |-> user1["authInfo"]]  \* authenticator recoit un request de user1 -> il recoit la valeur de authInfo: verifier P7
         \*/\ user1' = [id |-> id1, authInfo |-> authInfoini1 , authenticator |-> authenticator["id"], idProof |-> idProof1]  \* generation d'un idProof une fois P7 est verifie
         \* /\ user1' =[id |-> 3, authInfo |-> authInfoini1 , authenticator |-> authenticator["id"], idProof |-> idProof] \* verifier P1
         \* /\ user1' = [id |-> id2, authInfo |-> authInfoini1 , authenticator |-> authenticator["id"], idProof |-> idProof] \* verifier P2
         \* /\ user1' = [id |-> id1, authInfo |-> authInfoini2 , authenticator |-> authenticator["id"], idProof |-> idProof] \* verifier P4 et P3
         \* /\ authenticator' = [id |-> 3, authInfo |-> authInfo]  \*verifier P5
         \* /\ user1' = [id |-> id1, authInfo |-> authInfoini1 , authenticator |-> 2, idProof |-> idProof] \* verifier P6
         /\ UNCHANGED <<user1,authenticator,user2>> 
 

=============================================================================
\* Modification History
\* Last modified Fri Feb 18 00:15:03 CET 2022 by Lara
\* Created Mon Feb 07 13:14:04 CET 2022 by Lara
