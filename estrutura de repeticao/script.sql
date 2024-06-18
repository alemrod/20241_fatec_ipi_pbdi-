DO $$
DECLARE
    aluno RECORD;
    media NUMERIC(10, 2) := 0;
    total INT;
BEGIN
    FOR aluno IN
        SELECT * FROM tb_aluno
    LOOP
        -- mostrar a nota do aluno atual
        RAISE NOTICE 'Nota do aluno é %', aluno.nota;
        -- acumular a media
        media := media +aluno.nota;
    END LOOP;
    -- guardar a quantidade de linhas na variável total
   	SELECT COUNT(*) FROM tb_aluno INTO total;
	RAISE NOTICE 'A media foi %', media / total;
END;
$$