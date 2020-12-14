CREATE OR REPLACE PACKAGE PKG_COLLECTION_LHR AUTHID CURRENT_USER AS

  -----------------------------------------------------------------------------------
  -- Created on 2013-05-24 14:37:41 by lhr
  --Changed on 2013-05-24 14:37:41 by lhr
  -- function：  返回各种各样的集合   
	/*
	DROP TYPE obj_all_address_lhr FORCE;
DROP TYPE typ_all_address_lhr FORCE;
 
CREATE OR REPLACE TYPE obj_all_address_lhr AS OBJECT(
    P_LEVEL        NUMBER(18),
    EMPNO          NUMBER(18),
    ENAME          VARCHAR2(4000),
    MGR            NUMBER(18),
    NAME_ALL     VARCHAR2(4000),
    ALL_NAME_LEVEL VARCHAR2(4000),
    ROOT           VARCHAR2(4000),
    IS_LEAF        VARCHAR2(10)
    );
CREATE OR REPLACE TYPE typ_all_address_lhr AS TABLE OF obj_all_address_lhr;
*/
  -----------------------------------------------------------------------------------

  -----------------------------变量--------------------------------------
  TYPE TYPE_CURSOR IS REF CURSOR;
  TYPE TYPE_RECORD IS RECORD(
    P_LEVEL        NUMBER(18),
    EMPNO          NUMBER(18),
    ENAME          VARCHAR2(4000),
    MGR            NUMBER(18),
    NAME_ALL     VARCHAR2(4000),
    ALL_NAME_LEVEL VARCHAR2(4000),
    ROOT           VARCHAR2(4000),
    IS_LEAF        VARCHAR2(10));
  TYPE T_RECORD IS TABLE OF TYPE_RECORD;

  -----------------------------存过--------------------------------------
  --系统游标  --推荐
  PROCEDURE P_SYS_REFCURSOR_LHR(P_EMPNO IN NUMBER,
                                CUR_SYS     OUT SYS_REFCURSOR);
  -- 自定义游标
  PROCEDURE P_SYS_REFCURSOR_LHR_01(P_EMPNO IN NUMBER,
                                   CUR_SYS     OUT TYPE_CURSOR);

  ---索引表  --包级别
  PROCEDURE P_INDEX_TABLE_PKG_LHR(P_EMPNO IN NUMBER,
                                  O_T_RECORD  OUT T_RECORD);

  ------------------------------函数-------------------------------------
  --系统游标
  FUNCTION F_GET_SYS_REFCURSOR_LHR(P_EMPNO NUMBER) RETURN SYS_REFCURSOR;

  --索引表   --包 级别   不能通过sql语句直接查询
  FUNCTION F_GET_INDEX_TABLE_PKG_LHR(P_EMPNO NUMBER) RETURN T_RECORD;

  --索引表   --schema 级别  可以直接查询
  /*select D.*   from table( f_get_all_address_lhr(306628323)) D;
  select * from the(select  f_get_all_address_lhr(306628323) from dual);*/
  FUNCTION F_GET_INDEX_TABLE_SCHEMA_LHR(P_EMPNO NUMBER)
    RETURN TYP_ALL_ADDRESS_LHR;

  ---- 索引表   --schema 级别 --管道化 可以直接查询
  FUNCTION F_GET_INDEX_TABLE_PIPE_LHR(P_EMPNO NUMBER)
    RETURN TYP_ALL_ADDRESS_LHR
    PIPELINED;

END PKG_COLLECTION_LHR;
/
CREATE OR REPLACE PACKAGE BODY PKG_COLLECTION_LHR AS

  PROCEDURE P_SYS_REFCURSOR_LHR(P_EMPNO IN NUMBER,
                                CUR_SYS     OUT SYS_REFCURSOR) IS
  
    /*DECLARE
  CUR_A         SYS_REFCURSOR;
  R_TYPE_RECORD PKG_COLLECTION_LHR.TYPE_RECORD;
BEGIN
  PKG_COLLECTION_LHR.P_SYS_REFCURSOR_LHR(7900, CUR_A);
  LOOP
    FETCH CUR_A
      INTO R_TYPE_RECORD;
    EXIT WHEN CUR_A%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(R_TYPE_RECORD.EMPNO);
  END LOOP;
END;
*/
  BEGIN
    OPEN CUR_SYS FOR
      SELECT LEVEL P_LEVEL,
             T.EMPNO,
             T.ENAME,
             T.MGR,
             (LPAD(' ', 6 * (LEVEL - 1)) || LEVEL || ':' || T.ENAME || '(' ||
             T.EMPNO || ')') NAME_ALL,
             SUBSTR(SYS_CONNECT_BY_PATH(T.ENAME, '=>'), 3) ALL_NAME_LEVEL,
             CONNECT_BY_ROOT(T.ENAME) ROOT,
             DECODE(CONNECT_BY_ISLEAF, 1, 'Y', 0, 'N') IS_LEAF
        FROM SCOTT.EMP T
       START WITH MGR IS NULL
      CONNECT BY NOCYCLE MGR = PRIOR EMPNO;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END P_SYS_REFCURSOR_LHR;

  ------------------------------------------------------------------------------------------------------
  PROCEDURE P_SYS_REFCURSOR_LHR_01(P_EMPNO IN NUMBER,
                                   CUR_SYS     OUT TYPE_CURSOR) IS
  
    /*  --测试：
  DECLARE
  CUR_A         PKG_COLLECTION_LHR.TYPE_CURSOR;
  R_TYPE_RECORD PKG_COLLECTION_LHR.TYPE_RECORD;
BEGIN
  PKG_COLLECTION_LHR.P_SYS_REFCURSOR_LHR_01(7809, CUR_A);
  LOOP
    FETCH CUR_A
      INTO R_TYPE_RECORD;
    EXIT WHEN CUR_A%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(R_TYPE_RECORD.EMPNO);
  END LOOP;
END;
*/
  BEGIN
    OPEN CUR_SYS FOR
      SELECT LEVEL P_LEVEL,
             T.EMPNO,
             T.ENAME,
             T.MGR,
             (LPAD(' ', 6 * (LEVEL - 1)) || LEVEL || ':' || T.ENAME || '(' ||
             T.EMPNO || ')') NAME_ALL,
             SUBSTR(SYS_CONNECT_BY_PATH(T.ENAME, '=>'), 3) ALL_NAME_LEVEL,
             CONNECT_BY_ROOT(T.ENAME) ROOT,
             DECODE(CONNECT_BY_ISLEAF, 1, 'Y', 0, 'N') IS_LEAF
        FROM SCOTT.EMP T
       START WITH MGR IS NULL
      CONNECT BY NOCYCLE MGR = PRIOR EMPNO;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END P_SYS_REFCURSOR_LHR_01;

  ------------------------------------------------------------------------------------------------------

  PROCEDURE P_INDEX_TABLE_PKG_LHR(P_EMPNO IN NUMBER,
                                  O_T_RECORD  OUT T_RECORD) IS
           /*  --测试：
  DECLARE
  CUR_A         PKG_COLLECTION_LHR.TYPE_CURSOR;
  R_TYPE_RECORD PKG_COLLECTION_LHR.TYPE_RECORD;
BEGIN
  PKG_COLLECTION_LHR.P_SYS_REFCURSOR_LHR_01(306628323, CUR_A);
  LOOP
    FETCH CUR_A
      INTO R_TYPE_RECORD;
    EXIT WHEN CUR_A%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(R_TYPE_RECORD.EMPNO);
  END LOOP;
END;
*/

    R_TYPE TYPE_RECORD;
  
  BEGIN
    O_T_RECORD := T_RECORD(); -- 注意这句不能丢  不然会报：ORA-06531: 引用未初始化的收集
    FOR CUR IN (SELECT LEVEL P_LEVEL,
                       T.EMPNO,
                       T.ENAME,
                       T.MGR,
                       (LPAD(' ', 6 * (LEVEL - 1)) || LEVEL || ':' ||
                       T.ENAME || '(' || T.EMPNO || ')') NAME_ALL,
                       SUBSTR(SYS_CONNECT_BY_PATH(T.ENAME, '=>'), 3) ALL_NAME_LEVEL,
                       CONNECT_BY_ROOT(T.ENAME) ROOT,
                       DECODE(CONNECT_BY_ISLEAF, 1, 'Y', 0, 'N') IS_LEAF
                  FROM SCOTT.EMP T
                 START WITH MGR IS NULL
                CONNECT BY NOCYCLE MGR = PRIOR EMPNO) LOOP 
      R_TYPE.P_LEVEL        := CUR.P_LEVEL;
      R_TYPE.ALL_NAME_LEVEL := CUR.ALL_NAME_LEVEL;
      R_TYPE.ROOT           := CUR.ROOT;
      R_TYPE.IS_LEAF        := CUR.IS_LEAF;
      O_T_RECORD.EXTEND;
      O_T_RECORD(O_T_RECORD.LAST) := R_TYPE;
    END LOOP;
  
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END P_INDEX_TABLE_PKG_LHR;
  ------------------------------------------------------------------------------------------------------

  ------------------------------------------------------------------------------------------------------

  FUNCTION F_GET_SYS_REFCURSOR_LHR(P_EMPNO NUMBER) RETURN SYS_REFCURSOR IS
  
    -----------------------------------------------------------------------------------
    -- Created on 2013-05-24 14:37:41 by lhr
    --Changed on 2013-05-24 14:37:41 by lhr
    -- function：
    --测试： SELECT pkg_collection_lhr.f_get_SYS_REFCURSOR_lhr(306628323)  FROM   dual;
    -----------------------------------------------------------------------------------
  
    CUR_SYS SYS_REFCURSOR;
  BEGIN
    OPEN CUR_SYS FOR
      SELECT LEVEL P_LEVEL,
             T.EMPNO,
             T.ENAME,
             T.MGR,
             (LPAD(' ', 6 * (LEVEL - 1)) || LEVEL || ':' || T.ENAME || '(' ||
             T.EMPNO || ')') NAME_ALL,
             SUBSTR(SYS_CONNECT_BY_PATH(T.ENAME, '=>'), 3) ALL_NAME_LEVEL,
             CONNECT_BY_ROOT(T.ENAME) ROOT,
             DECODE(CONNECT_BY_ISLEAF, 1, 'Y', 0, 'N') IS_LEAF
        FROM SCOTT.EMP T
       START WITH MGR IS NULL
      CONNECT BY NOCYCLE MGR = PRIOR EMPNO;
  
    RETURN CUR_SYS;
  EXCEPTION
    WHEN OTHERS THEN
      NULL;
  END;

  ------------------------------------------------------------------------------------------------------

  FUNCTION F_GET_INDEX_TABLE_PKG_LHR(P_EMPNO NUMBER) RETURN T_RECORD IS
    O_T_RECORD T_RECORD;
    R_TYPE     TYPE_RECORD;
  
    /*DECLARE
    RESULT pkg_collection_lhr.t_record;
    BEGIN
    -- Call the function
    RESULT := pkg_collection_lhr.f_get_index_table_pkg_lhr(P_EMPNO => 306628323);
    
    dbms_output.put_line(RESULT(1).id);
    END;*/
  
  BEGIN
    O_T_RECORD := T_RECORD(); -- 注意这句不能丢  不然会报：ORA-06531: 引用未初始化的收集
    FOR CUR IN (SELECT LEVEL P_LEVEL,
                       T.EMPNO,
                       T.ENAME,
                       T.MGR,
                       (LPAD(' ', 6 * (LEVEL - 1)) || LEVEL || ':' ||
                       T.ENAME || '(' || T.EMPNO || ')') NAME_ALL,
                       SUBSTR(SYS_CONNECT_BY_PATH(T.ENAME, '=>'), 3) ALL_NAME_LEVEL,
                       CONNECT_BY_ROOT(T.ENAME) ROOT,
                       DECODE(CONNECT_BY_ISLEAF, 1, 'Y', 0, 'N') IS_LEAF
                  FROM SCOTT.EMP T
                 START WITH MGR IS NULL
                CONNECT BY NOCYCLE MGR = PRIOR EMPNO) LOOP
    
      R_TYPE.P_LEVEL        := CUR.P_LEVEL;
      R_TYPE.ALL_NAME_LEVEL := CUR.ALL_NAME_LEVEL;
      R_TYPE.ROOT           := CUR.ROOT;
      R_TYPE.IS_LEAF        := CUR.IS_LEAF;
      O_T_RECORD.EXTEND;
      O_T_RECORD(O_T_RECORD.LAST) := R_TYPE;
    
      RETURN O_T_RECORD;
    END LOOP;
  END F_GET_INDEX_TABLE_PKG_LHR;

  -----------------------------------------------------------------------------------
  -- Created on 2012/8/20 11:33:07 by lhr
  --Changed on 2012/8/20 11:33:07 by lhr
  -- function：

  /*select D.*   from table( f_get_all_address_lhr(306628323)) D;
  select * from the(select  f_get_all_address_lhr(306628323) from dual);*/
  -----------------------------------------------------------------------------------
  FUNCTION F_GET_INDEX_TABLE_SCHEMA_LHR(P_EMPNO NUMBER)
    RETURN TYP_ALL_ADDRESS_LHR IS
  
    SP_TABLE_LHR TYP_ALL_ADDRESS_LHR := TYP_ALL_ADDRESS_LHR();
  
    -- sp_table_lhr typ_all_address_lhr ;
  BEGIN
  
    SELECT OBJ_ALL_ADDRESS_LHR(P_LEVEL,
                               EMPNO,
                               ENAME,
                               MGR,
                               NAME_ALL,
                               ALL_NAME_LEVEL,
                               ROOT,
                               IS_LEAF)
      BULK COLLECT
      INTO SP_TABLE_LHR
      FROM (SELECT LEVEL P_LEVEL,
                   T.EMPNO,
                   T.ENAME,
                   T.MGR,
                   (LPAD(' ', 6 * (LEVEL - 1)) || LEVEL || ':' || T.ENAME || '(' ||
                   T.EMPNO || ')') NAME_ALL,
                   SUBSTR(SYS_CONNECT_BY_PATH(T.ENAME, '=>'), 3) ALL_NAME_LEVEL,
                   CONNECT_BY_ROOT(T.ENAME) ROOT,
                   DECODE(CONNECT_BY_ISLEAF, 1, 'Y', 0, 'N') IS_LEAF
              FROM SCOTT.EMP T
             START WITH MGR IS NULL
            CONNECT BY NOCYCLE MGR = PRIOR EMPNO);
  
    ---或者用如下的for循环
    /*    FOR cur IN (SELECT LEVEL p_level,
    t.id,
    t.parentid,
    t.assemblename,
    t.addresslevel,
    (SELECT d.description
    FROM   x_dictionary d
    WHERE  d. classid = 'ADDRESS'
    AND    d.attributeid = 'ADDRESSLEVEL'
    AND    d.value = t.addresslevel) add_level_description,
    (lpad(' ', 6 * (LEVEL - 1)) || LEVEL || ':' || t.name || '(' || t.id || ')') NAME_ALL,
    substr(sys_connect_by_path(t.name, '=>'), 3) all_name_level,
    connect_by_root(t.name) root,
    decode(connect_by_isleaf, 1, 'Y', 0, 'N') is_leaf
    FROM   xb_address t
    START  WITH t.id = P_EMPNO
    CONNECT BY nocycle PRIOR t.parentid = id) LOOP
    
    sp_table_lhr.EXTEND;
    sp_table_lhr(sp_table_lhr.last) := obj_all_address_lhr('',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '');
    sp_table_lhr(sp_table_lhr.last).p_level := cur.p_level;
    sp_table_lhr(sp_table_lhr.last).id := cur.id;
    sp_table_lhr(sp_table_lhr.last).parentid := cur.parentid;
    END LOOP;
    */
  
    ---或者用如下的for循环
    /*              FOR cur IN (SELECT LEVEL p_level,
    t.id,
    t.parentid,
    t.assemblename,
    t.addresslevel,
    (SELECT d.description
    FROM   x_dictionary d
    WHERE  d. classid = 'ADDRESS'
    AND    d.attributeid = 'ADDRESSLEVEL'
    AND    d.value = t.addresslevel) add_level_description,
    (lpad(' ', 6 * (LEVEL - 1)) || LEVEL || ':' || t.name || '(' || t.id || ')') NAME_ALL,
    substr(sys_connect_by_path(t.name, '=>'), 3) all_name_level,
    connect_by_root(t.name) root,
    decode(connect_by_isleaf, 1, 'Y', 0, 'N') is_leaf
    FROM   xb_address t
    START  WITH t.id = P_EMPNO
    CONNECT BY nocycle PRIOR t.parentid = id) LOOP
    
    sp_table_lhr.EXTEND;
    sp_table_lhr(sp_table_lhr.last) := obj_all_address_lhr(cur.p_level,
    cur.id,
    cur.parentid,
    cur.assemblename,
    cur.addresslevel,
    cur.add_level_description,
    cur.NAME_ALL,
    cur.all_name_level,
    cur.root,
    cur.is_leaf);
    END LOOP;
    */
    RETURN SP_TABLE_LHR;
  END F_GET_INDEX_TABLE_SCHEMA_LHR;

  ------------------------------------------------------------------------------------------------------
  FUNCTION F_GET_INDEX_TABLE_PIPE_LHR(P_EMPNO NUMBER)
    RETURN TYP_ALL_ADDRESS_LHR
    PIPELINED IS
  
    SP_TABLE_LHR OBJ_ALL_ADDRESS_LHR;
  BEGIN
  
    FOR CUR IN (SELECT LEVEL P_LEVEL,
                       T.EMPNO,
                       T.ENAME,
                       T.MGR,
                       (LPAD(' ', 6 * (LEVEL - 1)) || LEVEL || ':' ||
                       T.ENAME || '(' || T.EMPNO || ')') NAME_ALL,
                       SUBSTR(SYS_CONNECT_BY_PATH(T.ENAME, '=>'), 3) ALL_NAME_LEVEL,
                       CONNECT_BY_ROOT(T.ENAME) ROOT,
                       DECODE(CONNECT_BY_ISLEAF, 1, 'Y', 0, 'N') IS_LEAF
                  FROM SCOTT.EMP T
                 START WITH MGR IS NULL
                CONNECT BY NOCYCLE MGR = PRIOR EMPNO) LOOP
    
      SP_TABLE_LHR := OBJ_ALL_ADDRESS_LHR(CUR.P_LEVEL,
                                          CUR.Empno,
                                          CUR.Ename,
                                          CUR.Mgr,
                                          cur.NAME_ALL,
                                          CUR.ALL_NAME_LEVEL,
                                          CUR.ROOT,
                                          CUR.IS_LEAF);
      PIPE ROW(SP_TABLE_LHR);
    
    END LOOP;
  
    RETURN;
  END F_GET_INDEX_TABLE_PIPE_LHR;

END PKG_COLLECTION_LHR;
/
