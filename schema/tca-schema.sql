-- =============================================================
-- TCA (TOTVS Commercial AI) — schema executável
-- Requer PostgreSQL 13+ (gen_random_uuid nativo) e pgvector.
-- =============================================================

BEGIN;

CREATE EXTENSION IF NOT EXISTS vector;

-- -------------------------------------------------------------
-- Base: endereços, tenants, usuários e perfis
-- -------------------------------------------------------------

CREATE TABLE public.addresses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  postalcode character(8) NOT NULL,
  number character varying NOT NULL,
  name character varying NOT NULL,
  complement character varying,
  state character varying NOT NULL,
  uf character(2) NOT NULL,
  neighborhood character varying NOT NULL,
  CONSTRAINT addresses_pkey PRIMARY KEY (id)
);

CREATE TABLE public.tenants (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL,
  fantasy_name character varying NOT NULL UNIQUE,
  cnpj character(14) NOT NULL UNIQUE,
  email character varying UNIQUE,
  phone character varying UNIQUE,
  address_id uuid NOT NULL,
  status character varying NOT NULL CHECK (status IN ('ACTIVE', 'INACTIVE')),
  is_deleted boolean NOT NULL DEFAULT false,
  created_on timestamp with time zone NOT NULL DEFAULT now(),
  updated_on timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT tenants_pkey PRIMARY KEY (id),
  CONSTRAINT tenants_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id)
);

CREATE TABLE public.users (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  full_name character varying NOT NULL,
  username character varying NOT NULL UNIQUE,
  cpf character(11) NOT NULL UNIQUE,
  mobile_phone character varying,
  birth_date date NOT NULL,
  email character varying NOT NULL,
  password character varying NOT NULL,
  profile_photo_url character varying,
  address_id uuid NOT NULL,
  score integer DEFAULT 0,
  ai_token_used integer DEFAULT 0,
  status character varying NOT NULL CHECK (status IN (
    'FORCE_CHANGE_PASSWORD', 'ACTIVE', 'INACTIVE', 'BANNED', 'FIRST_LOGIN', 'CHECKING_MFA'
  )),
  is_deleted boolean NOT NULL DEFAULT false,
  use_mfa boolean NOT NULL DEFAULT false,
  mfa_token character varying,
  modified_on timestamp with time zone NOT NULL DEFAULT now(),
  created_by uuid,
  created_on timestamp with time zone NOT NULL DEFAULT now(),
  tenant_id uuid,
  CONSTRAINT users_pkey PRIMARY KEY (id),
  CONSTRAINT users_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id),
  CONSTRAINT users_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id),
  CONSTRAINT users_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id)
);

CREATE TABLE public.profiles (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL,
  is_admin boolean NOT NULL DEFAULT false,
  CONSTRAINT profiles_pkey PRIMARY KEY (id)
);

CREATE TABLE public.user_profiles (
  user_id uuid NOT NULL,
  profile_id uuid NOT NULL,
  CONSTRAINT user_profiles_pkey PRIMARY KEY (user_id, profile_id),
  CONSTRAINT user_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT user_profiles_profile_id_fkey FOREIGN KEY (profile_id) REFERENCES public.profiles(id)
);

-- -------------------------------------------------------------
-- Estrutura comercial: gerentes, squads, vendedores, clientes
-- -------------------------------------------------------------

CREATE TABLE public.managers (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE,
  total_meetings integer NOT NULL DEFAULT 0,
  total_squads smallint NOT NULL DEFAULT 0,
  unit character varying,
  score_goal smallint,
  created_by uuid NOT NULL,
  created_on timestamp with time zone NOT NULL DEFAULT now(),
  modified_on timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT managers_pkey PRIMARY KEY (id),
  CONSTRAINT managers_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT managers_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id)
);

CREATE TABLE public.squads (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  code character varying NOT NULL UNIQUE,
  name character varying NOT NULL,
  manager_id uuid NOT NULL,
  description character varying NOT NULL,
  performance_avg smallint NOT NULL DEFAULT 0,
  CONSTRAINT squads_pkey PRIMARY KEY (id),
  CONSTRAINT squads_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES public.managers(id)
);

CREATE TABLE public.salespersons (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL UNIQUE,
  total_meetings integer NOT NULL DEFAULT 0,
  need_training boolean NOT NULL DEFAULT false,
  squad_id uuid NOT NULL,
  tenant_id uuid NOT NULL,
  CONSTRAINT salespersons_pkey PRIMARY KEY (id),
  CONSTRAINT salespersons_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id),
  CONSTRAINT salespersons_squad_id_fkey FOREIGN KEY (squad_id) REFERENCES public.squads(id),
  CONSTRAINT salespersons_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id)
);

CREATE TABLE public.clients (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  name character varying NOT NULL,
  fantasy_name character varying NOT NULL,
  segment character varying,
  cnpj character(14) NOT NULL UNIQUE,
  email character varying UNIQUE,
  phone character varying UNIQUE,
  address_id uuid NOT NULL,
  squad_id uuid NOT NULL,
  revenue numeric DEFAULT 0,
  status character varying NOT NULL CHECK (status IN ('CRITIC', 'BAD', 'OK', 'GOOD', 'DELETED', 'UNDEFINED')),
  is_deleted boolean NOT NULL DEFAULT false,
  embeddings vector,
  score numeric DEFAULT 0,
  CONSTRAINT clients_pkey PRIMARY KEY (id),
  CONSTRAINT clients_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.addresses(id),
  CONSTRAINT clients_squad_id_fkey FOREIGN KEY (squad_id) REFERENCES public.squads(id)
);

-- -------------------------------------------------------------
-- Reuniões e transcrições
-- -------------------------------------------------------------

CREATE TABLE public.transcripts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  raw_transcript text NOT NULL,
  resume text NOT NULL,
  status character varying NOT NULL CHECK (status IN ('NOT_STARTED', 'IN_PROGRESS', 'DONE', 'ERROR', 'CANCELLED')),
  CONSTRAINT transcripts_pkey PRIMARY KEY (id)
);

CREATE TABLE public.transcript_chunks (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  transcript_id uuid NOT NULL,
  chunk_text text NOT NULL,
  embedding vector NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT transcript_chunks_pkey PRIMARY KEY (id),
  CONSTRAINT transcript_chunks_transcript_id_fkey FOREIGN KEY (transcript_id) REFERENCES public.transcripts(id)
);

CREATE TABLE public.meetings (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  totvs_id character varying UNIQUE,
  transcript_id uuid UNIQUE,
  client_represent character varying,
  title character varying NOT NULL,
  summary text,
  scheduled timestamp with time zone NOT NULL,
  duration_min integer,
  status character varying NOT NULL CHECK (status IN ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED')),
  performance_avg smallint,
  priority character varying CHECK (priority IN ('HIGH', 'MEDIUM', 'LOW')),
  is_deleted boolean NOT NULL DEFAULT false,
  rating smallint NOT NULL,
  embeddings vector,
  tenant_id uuid,
  scope text CHECK (scope IN ('EXTERNAL', 'INTERNAL')),
  CONSTRAINT meetings_pkey PRIMARY KEY (id),
  CONSTRAINT meetings_transcript_id_fkey FOREIGN KEY (transcript_id) REFERENCES public.transcripts(id),
  CONSTRAINT meetings_tenant_id_fkey FOREIGN KEY (tenant_id) REFERENCES public.tenants(id)
);

CREATE TABLE public.meeting_employees (
  meeting_id uuid NOT NULL,
  user_id uuid NOT NULL,
  CONSTRAINT meeting_employees_pkey PRIMARY KEY (meeting_id, user_id),
  CONSTRAINT meeting_employees_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id),
  CONSTRAINT meeting_employees_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);

CREATE TABLE public.meeting_client_details (
  meeting_id uuid NOT NULL,
  client_id uuid NOT NULL,
  CONSTRAINT meeting_client_details_pkey PRIMARY KEY (meeting_id),
  CONSTRAINT meeting_client_details_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id),
  CONSTRAINT meeting_client_details_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id)
);

CREATE TABLE public.meeting_stakeholders (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  meeting_id uuid NOT NULL,
  name character varying NOT NULL,
  role character varying,
  side character varying CHECK (side IN ('CLIENT', 'COMPANY', 'UNKNOWN')),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT meeting_stakeholders_pkey PRIMARY KEY (id),
  CONSTRAINT meeting_stakeholders_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id)
);

-- -------------------------------------------------------------
-- Análises, scores e predições
-- -------------------------------------------------------------

CREATE TABLE public.meeting_strategic_analyses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  meeting_id uuid NOT NULL UNIQUE,
  client_id uuid NOT NULL,
  feedback text NOT NULL,
  tips text NOT NULL,
  company_status character varying NOT NULL CHECK (company_status IN ('GOOD', 'OK', 'BAD', 'CRITIC')),
  company_performance numeric NOT NULL,
  closing_probability numeric NOT NULL,
  flexibility numeric NOT NULL,
  risk numeric NOT NULL,
  financial_impact numeric NOT NULL,
  financial_impact_value numeric,
  financial_impact_status character varying NOT NULL CHECK (financial_impact_status IN ('MINIMAL', 'LOW', 'MEDIUM', 'HIGH', 'SEVERAL')),
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT meeting_strategic_analyses_pkey PRIMARY KEY (id),
  CONSTRAINT meeting_strategic_analyses_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id),
  CONSTRAINT meeting_strategic_analyses_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id)
);

CREATE TABLE public.meeting_performance_analyses (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  meeting_id uuid NOT NULL UNIQUE,
  feedback text NOT NULL,
  engagement numeric NOT NULL,
  communication_quality numeric NOT NULL,
  opportunities_seized numeric NOT NULL,
  objection_handling numeric NOT NULL,
  missed_opportunities numeric NOT NULL DEFAULT 0,
  leads_converted integer NOT NULL,
  tips text NOT NULL,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT meeting_performance_analyses_pkey PRIMARY KEY (id),
  CONSTRAINT meeting_performance_analyses_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id)
);

CREATE TABLE public.meeting_strategic_scores (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  meeting_id uuid NOT NULL UNIQUE,
  client_id uuid NOT NULL,
  base_score numeric NOT NULL,
  multiplier numeric NOT NULL,
  wallet_percentage numeric,
  financial_impact_level character varying CHECK (financial_impact_level IN ('HIGH', 'MEDIUM', 'LOW')),
  financial_factor numeric NOT NULL DEFAULT 1.00,
  final_score numeric NOT NULL,
  calculated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT meeting_strategic_scores_pkey PRIMARY KEY (id),
  CONSTRAINT meeting_strategic_scores_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id),
  CONSTRAINT meeting_strategic_scores_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id)
);

CREATE TABLE public.meeting_performance_scores (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  meeting_id uuid NOT NULL,
  salesperson_id uuid NOT NULL,
  base_score numeric NOT NULL,
  multiplier numeric NOT NULL,
  streak_type character varying CHECK (streak_type IN ('HIGH', 'FALL', 'STABLE')),
  streak_count smallint NOT NULL DEFAULT 0,
  final_score numeric NOT NULL,
  calculated_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT meeting_performance_scores_pkey PRIMARY KEY (id),
  CONSTRAINT meeting_performance_scores_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id),
  CONSTRAINT meeting_performance_scores_salesperson_id_fkey FOREIGN KEY (salesperson_id) REFERENCES public.salespersons(id)
);

CREATE TABLE public.meeting_predicts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  meeting_id uuid NOT NULL UNIQUE,
  predict text,
  status character varying NOT NULL DEFAULT 'CREATED' CHECK (status IN ('CREATED', 'PROCESSING', 'COMPLETED', 'CANCELLED')),
  reprocess boolean DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT meeting_predicts_pkey PRIMARY KEY (id),
  CONSTRAINT meeting_predicts_meeting_id_fkey FOREIGN KEY (meeting_id) REFERENCES public.meetings(id)
);

CREATE TABLE public.client_predicts (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  client_id uuid NOT NULL UNIQUE,
  predict text,
  status character varying NOT NULL DEFAULT 'CREATED' CHECK (status IN ('CREATED', 'PROCESSING', 'COMPLETED', 'CANCELLED')),
  reprocess boolean DEFAULT false,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT client_predicts_pkey PRIMARY KEY (id),
  CONSTRAINT client_predicts_client_id_fkey FOREIGN KEY (client_id) REFERENCES public.clients(id)
);

-- -------------------------------------------------------------
-- Chat com IA
-- -------------------------------------------------------------

CREATE TABLE public.sessions (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  title character varying NOT NULL,
  last_activity timestamp with time zone NOT NULL DEFAULT now(),
  created_on timestamp with time zone NOT NULL DEFAULT now(),
  user_id uuid NOT NULL,
  model_used character varying NOT NULL CHECK (model_used IN ('FAST', 'PRO')),
  last_interaction_id character varying,
  is_deleted boolean NOT NULL DEFAULT false,
  deleted_on timestamp with time zone,
  CONSTRAINT sessions_pkey PRIMARY KEY (id),
  CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);

CREATE TABLE public.messages (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL,
  role character varying NOT NULL CHECK (role IN ('SALESPERSON', 'MANAGER', 'TOTVS_AI')),
  content text NOT NULL,
  created_on timestamp with time zone NOT NULL DEFAULT now(),
  interaction_id character varying,
  CONSTRAINT messages_pkey PRIMARY KEY (id),
  CONSTRAINT messages_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.sessions(id)
);

-- -------------------------------------------------------------
-- Configurações, auditoria e e-mail
-- -------------------------------------------------------------

CREATE TABLE public.configurations (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  key character varying NOT NULL UNIQUE,
  type character varying NOT NULL CHECK (type IN ('STRING', 'INTEGER', 'DOUBLE', 'BOOLEAN')),
  content text NOT NULL,
  CONSTRAINT configurations_pkey PRIMARY KEY (id)
);

CREATE TABLE public.audits (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  entity_name character varying NOT NULL,
  user_id uuid,
  created_at timestamp with time zone NOT NULL DEFAULT now(),
  previous jsonb,
  "new" jsonb,
  CONSTRAINT audits_pkey PRIMARY KEY (id),
  CONSTRAINT audits_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id)
);

CREATE TABLE public.template (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  subject text NOT NULL,
  body text NOT NULL,
  created_on timestamp with time zone NOT NULL DEFAULT now(),
  updated_on timestamp with time zone NOT NULL DEFAULT now(),
  CONSTRAINT template_pkey PRIMARY KEY (id)
);

CREATE TABLE public.email (
  id uuid NOT NULL DEFAULT gen_random_uuid(),
  "from" character varying NOT NULL,
  "to" character varying NOT NULL,
  subject character varying NOT NULL,
  body text NOT NULL,
  template_id uuid NOT NULL,
  status character varying NOT NULL DEFAULT 'PENDING' CHECK (status IN ('PENDING', 'SENT', 'FAILED', 'SKIPPED')),
  created_on timestamp with time zone NOT NULL DEFAULT now(),
  updated_on timestamp with time zone NOT NULL DEFAULT now(),
  scheduled_at timestamp with time zone,
  CONSTRAINT email_pkey PRIMARY KEY (id),
  CONSTRAINT email_template_id_fkey FOREIGN KEY (template_id) REFERENCES public.template(id)
);

COMMIT;