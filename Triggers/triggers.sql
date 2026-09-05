-- =========================================================================
-- NÃO auditadas de propósito:
--   transcript_chunks       -> dado derivado, regenerável
--   meeting_*_analyses      -> saída da IA, imutável após gravar
--   meeting_*_scores        -> recalculável a partir das análises
--   messages / sessions     -> histórico de chat já é o próprio registro
--   audits                  -> auditar a auditoria causaria recursão
-- =========================================================================

CREATE TRIGGER audit_users
    AFTER INSERT OR UPDATE OR DELETE ON "users"
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();
 
CREATE TRIGGER audit_clients
    AFTER INSERT OR UPDATE OR DELETE ON "clients"
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();
 
CREATE TRIGGER audit_meetings
    AFTER INSERT OR UPDATE OR DELETE ON "meetings"
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();
 
CREATE TRIGGER audit_meeting_employees
    AFTER INSERT OR UPDATE OR DELETE ON "meeting_employees"
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();
 
CREATE TRIGGER audit_salespersons
    AFTER INSERT OR UPDATE OR DELETE ON "salespersons"
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();
 
CREATE TRIGGER audit_managers
    AFTER INSERT OR UPDATE OR DELETE ON "managers"
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();
 
CREATE TRIGGER audit_squads
    AFTER INSERT OR UPDATE OR DELETE ON "squads"
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();
 
CREATE TRIGGER audit_profiles
    AFTER INSERT OR UPDATE OR DELETE ON "profiles"
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();
 
CREATE TRIGGER audit_user_profiles
    AFTER INSERT OR UPDATE OR DELETE ON "user_profiles"
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();
 
CREATE TRIGGER audit_configurations
    AFTER INSERT OR UPDATE OR DELETE ON "configurations"
    FOR EACH ROW EXECUTE FUNCTION audit_trigger();