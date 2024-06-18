-- 1.5 Procedimento com parâmetro VARIADIC
CREATE OR REPLACE PROCEDURE sp_cadastrar_clientes_variadic(
    INOUT p_mensagem TEXT,
    VARIADIC p_nomes VARCHAR[]
) LANGUAGE plpgsql AS $$
DECLARE
    v_nome VARCHAR;
BEGIN
    FOREACH v_nome IN ARRAY p_nomes
    LOOP
        INSERT INTO tb_cliente (nome) VALUES (v_nome);
    END LOOP;

    p_mensagem := 'Os clientes: ' || array_to_string(p_nomes, ', ') || ' foram cadastrados';

    -- Registrar log
    INSERT INTO log_operacoes (nome_procedimento) VALUES ('sp_cadastrar_clientes_variadic');
END;
$$;