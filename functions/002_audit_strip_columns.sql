CREATE OR REPLACE FUNCTION audit_strip_columns(payload JSONB)
RETURNS JSONB AS $$
BEGIN
    RETURN payload
        - 'embeddings'
        - 'embedding'
        - 'password'
        - 'mfa_token';
END;
$$ LANGUAGE plpgsql IMMUTABLE;