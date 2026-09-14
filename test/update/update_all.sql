-- 1) ADDRESSES
UPDATE "addresses"
SET "complement" = 'Sala 20', "neighborhood" = 'Jardins'
WHERE "id" = 'a0000000-0000-0000-0000-000000000001';

-- 2) PROFILES
UPDATE "profiles"
SET "name" = 'Administrador Master'
WHERE "id" = 'a0000000-0000-0000-0000-000000000002';

-- 3) TRANSCRIPTS
UPDATE "transcripts"
SET "status" = 'DONE', "resume" = 'Resumo revisado da reunião com o cliente.'
WHERE "id" = 'a0000000-0000-0000-0000-000000000003';

-- 4) CONFIGURATIONS
UPDATE "configurations"
SET "content" = '20000'
WHERE "id" = 'a0000000-0000-0000-0000-000000000004';

-- 5) TEMPLATE
UPDATE "template"
SET "subject" = 'Boas-vindas (atualizado)', "updated_on" = now()
WHERE "id" = 'a0000000-0000-0000-0000-000000000005';

-- 6) USERS
UPDATE "users"
SET "mobile_phone" = '11988887777', "score" = 150, "modified_on" = now()
WHERE "id" = 'a0000000-0000-0000-0000-000000000006';

-- 7) MANAGERS
UPDATE "managers"
SET "total_meetings" = 8, "score_goal" = 90, "modified_on" = now()
WHERE "id" = 'a0000000-0000-0000-0000-000000000007';

-- 8) SQUADS
UPDATE "squads"
SET "performance_avg" = 82, "description" = 'Squad premium (atualizada)'
WHERE "id" = 'a0000000-0000-0000-0000-000000000008';

-- 9) SALESPERSONS
UPDATE "salespersons"
SET "total_meetings" = 6, "need_training" = true
WHERE "id" = 'a0000000-0000-0000-0000-000000000009';

-- 10) CLIENTS
UPDATE "clients"
SET "revenue" = 65000.00, "status" = 'GOOD'
WHERE "id" = 'a0000000-0000-0000-0000-00000000000a';

-- 11) USER_PROFILES (PK composta, sem coluna própria além das FKs)
UPDATE "user_profiles"
SET "profile_id" = 'a0000000-0000-0000-0000-000000000002'
WHERE "user_id" = 'a0000000-0000-0000-0000-000000000006'
  AND "profile_id" = 'a0000000-0000-0000-0000-000000000002';

-- 12) MEETINGS
UPDATE "meetings"
SET "status" = 'COMPLETED', "performance_avg" = 85, "rating" = 4
WHERE "id" = 'a0000000-0000-0000-0000-00000000000b';

-- 13) MEETING_EMPLOYEES (PK composta, sem coluna própria além das FKs)
UPDATE "meeting_employees"
SET "user_id" = 'a0000000-0000-0000-0000-000000000006'
WHERE "meeting_id" = 'a0000000-0000-0000-0000-00000000000b'
  AND "user_id" = 'a0000000-0000-0000-0000-000000000006';

-- 14) SESSIONS
UPDATE "sessions"
SET "title" = 'Sessão de análise de reunião (revisada)', "last_activity" = now()
WHERE "id" = 'a0000000-0000-0000-0000-00000000000c';

-- 15) MESSAGES
UPDATE "messages"
SET "content" = 'Qual foi a nota final da última reunião?'
WHERE "id" = 'a0000000-0000-0000-0000-00000000000d';

-- 16) TRANSCRIPT_CHUNKS
UPDATE "transcript_chunks"
SET "chunk_text" = 'Trecho revisado da transcrição referente à abertura da reunião.'
WHERE "id" = 'a0000000-0000-0000-0000-00000000000e';

-- 17) AUDITS
UPDATE "audits"
SET "new" = '{"status": "CRITIC"}'::jsonb
WHERE "id" = 'a0000000-0000-0000-0000-00000000000f';

-- 18) MEETING_STRATEGIC_ANALYSES
UPDATE "meeting_strategic_analyses"
SET "company_status" = 'OK', "risk" = 4.50
WHERE "id" = 'a0000000-0000-0000-0000-000000000010';

-- 19) MEETING_PERFORMANCE_ANALYSES
UPDATE "meeting_performance_analyses"
SET "leads_converted" = 2, "tips" = 'Melhorar o fechamento e o follow-up.'
WHERE "id" = 'a0000000-0000-0000-0000-000000000011';

-- 20) MEETING_STRATEGIC_SCORES
UPDATE "meeting_strategic_scores"
SET "final_score" = 88.00, "financial_impact_level" = 'ALTO'
WHERE "id" = 'a0000000-0000-0000-0000-000000000012';

-- 21) MEETING_PERFORMANCE_SCORES
UPDATE "meeting_performance_scores"
SET "final_score" = 76.00, "streak_count" = 4
WHERE "id" = 'a0000000-0000-0000-0000-000000000013';

-- 22) EMAIL
UPDATE "email"
SET "status" = 'SENT', "updated_on" = now()
WHERE "id" = 'a0000000-0000-0000-0000-000000000014';

-- 23) MEETING_STAKEHOLDERS
UPDATE "meeting_stakeholders"
SET "role" = 'Diretora Executiva'
WHERE "id" = 'a0000000-0000-0000-0000-000000000015';

-- 24) MEETING_PREDICTS
UPDATE "meeting_predicts"
SET "status" = 'COMPLETED', "reprocess" = false
WHERE "id" = 'a0000000-0000-0000-0000-000000000016';
