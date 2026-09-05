CREATE OR REPLACE FUNCTION audit_trigger()
RETURNS TRIGGER AS $$
DECLARE
    v_user_id UUID;
    v_previous JSONB;
    v_new JSONB;
BEGIN
    -- Lê o autor da variável de sessão. O 'true' faz retornar NULL em vez
    -- de erro quando a variável não foi setada (ex: alteração via psql ou
    -- pelo microserviço Python).
    BEGIN
        v_user_id := NULLIF(current_setting('app.user_id', true), '')::UUID;
    EXCEPTION WHEN OTHERS THEN
        v_user_id := NULL;
    END;
 
    IF (TG_OP = 'INSERT') THEN
        v_previous := '{}'::JSONB;
        v_new := audit_strip_columns(to_jsonb(NEW));
 
    ELSIF (TG_OP = 'UPDATE') THEN
        v_previous := audit_strip_columns(to_jsonb(OLD));
        v_new := audit_strip_columns(to_jsonb(NEW));
 
        -- Se nada mudou fora das colunas ignoradas, não registra.
        -- Evita poluir a auditoria com updates que só tocaram embeddings.
        IF v_previous = v_new THEN
            RETURN NEW;
        END IF;
 
    ELSIF (TG_OP = 'DELETE') THEN
        v_previous := audit_strip_columns(to_jsonb(OLD));
        v_new := '{}'::JSONB;
    END IF;
 
    INSERT INTO audits (entity_name, user_id, previous, new)
    VALUES (TG_TABLE_NAME, v_user_id, v_previous, v_new);
 
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;