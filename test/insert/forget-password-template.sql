BEGIN;

INSERT INTO
    template
    (subject, body)
VALUES
    ('Recuperação de acesso ao TOTVS AI', '<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Sua senha temporária</title>
</head>
<body style="margin:0; padding:0; background-color:#EEF4F9; font-family:Helvetica, Arial, sans-serif;">

<div style="display:none; max-height:0; overflow:hidden; opacity:0;">
  Sua senha temporária de acesso está pronta. Use-a para entrar e cadastrar uma nova senha.
</div>

<table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#EEF4F9;">
  <tr>
    <td align="center" style="padding:32px 16px;">

      <table role="presentation" width="600" cellpadding="0" cellspacing="0" border="0" style="width:100%; max-width:600px; background-color:#FFFFFF; border-radius:8px; overflow:hidden;">

        <tr>
          <td style="background-color:#002D62; padding:28px 40px; border-bottom:4px solid #00B7D4;">
            <p style="margin:0; color:#FFFFFF; font-size:20px; font-weight:bold; letter-spacing:0.5px;">
              Recuperação de acesso
            </p>
          </td>
        </tr>

        <tr>
          <td style="padding:36px 40px 8px 40px;">
            <p style="margin:0 0 16px 0; color:#1E2E3D; font-size:17px; line-height:1.5; font-weight:bold;">
              Olá, {{nome_usuario}}
            </p>
            <p style="margin:0; color:#42566B; font-size:15px; line-height:1.6;">
              Recebemos um pedido de recuperação de senha para a conta vinculada a este e-mail.
              Geramos uma senha temporária para você entrar agora. Ao acessar o sistema,
              cadastre uma nova senha nas configurações da sua conta.
            </p>
          </td>
        </tr>

        <tr>
          <td style="padding:28px 40px;">
            <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color:#E4F6FB; border-left:5px solid #00B7D4; border-radius:6px;">
              <tr>
                <td align="center" style="padding:28px 24px;">
                  <p style="margin:0 0 10px 0; color:#00607A; font-size:13px; line-height:1.4;">
                    Senha temporária
                  </p>
                  <p style="margin:0; color:#002D62; font-size:30px; font-weight:bold; letter-spacing:4px; font-family:''Courier New'', Courier, monospace;">
                    {{senha_temporaria}}
                  </p>
                </td>
              </tr>
            </table>
          </td>
        </tr>

        <tr>
          <td align="center" style="padding:0 40px 32px 40px;">
            <table role="presentation" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td align="center" style="background-color:#0057B8; border-radius:6px;">
                  <a href="{{link_login}}" style="display:inline-block; padding:15px 40px; color:#FFFFFF; font-size:16px; font-weight:bold; text-decoration:none;">
                    Entrar e trocar a senha
                  </a>
                </td>
              </tr>
            </table>
          </td>
        </tr>

        <tr>
          <td style="padding:0 40px 36px 40px;">
            <table role="presentation" width="100%" cellpadding="0" cellspacing="0" border="0" style="border-top:1px solid #D6E4EF;">
              <tr>
                <td style="padding-top:20px;">
                  <p style="margin:0 0 10px 0; color:#42566B; font-size:14px; line-height:1.6;">
                    Esta senha expira em <strong style="color:#002D62;">{{tempo_expiracao}}</strong> e só pode ser usada uma vez.
                  </p>
                  <p style="margin:0; color:#42566B; font-size:14px; line-height:1.6;">
                    Se você não solicitou a recuperação, ignore este e-mail. Sua senha atual continua válida.
                  </p>
                </td>
              </tr>
            </table>
          </td>
        </tr>

        <tr>
          <td style="background-color:#F5F9FC; padding:22px 40px; border-top:1px solid #D6E4EF;">
            <p style="margin:0 0 6px 0; color:#6B7F91; font-size:12px; line-height:1.5;">
              Este é um e-mail automático. Não responda esta mensagem.
            </p>
            <p style="margin:0; color:#6B7F91; font-size:12px; line-height:1.5;">
              Precisa de ajuda? Fale com o suporte pelo canal de atendimento da sua empresa.
            </p>
          </td>
        </tr>

      </table>

    </td>
  </tr>
</table>

</body>
</html>');

SELECT * from template;

ROLLBACK;
COMMIT;