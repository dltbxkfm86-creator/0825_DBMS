/*
 * 		< DML : DATA MANIPULATION LANGUAGE >
 * 						조작	
 * 		
 * 		논외)  SELECT : DML / DQL
 * 
 * 		INSERT / UPDATE / DELETE
 * 
 * 		테이블에 새로운 데이터를 삽입(INSERT)하거나, 
 *		테이블에 존재하는 데이터를 수정(UPDATE)하거나,
 *		테이블에 존재하는 데이터를 삭제(DELETE)하는 구문
 */
/*
 * 1. INSERT : 테이블에 새로운 행을 추가해주는 구문
 * 
 * [ 표현법 ]
 * 
 * 1) INSERT INTO 테이블명 VALUES (값, 값, 값, ...);
 * 
 * => 해당 테이블에 모든 컬럼에 추가하고자 하는 값을 직접 입력해서 한 행을 INSERT할 때 사용
 *   주의할 점 : 값의 순서를 컬럼의 순서와 동일하게 작성해야 함
 */
SELECT * FROM EMPLOYEE;

INSERT 
  INTO 
	   EMPLOYEE 
VALUES 
	   (
		223
	 , '김태호'
	 , '991231-9999999'
	 , 'kth04@kh.or.kr'
	 , '01004044040'
	 , 'D9'
	 , 'J5'
	 , 'S4'
	 , 5000000
	 , NULL
	 , NULL
	 , SYSDATE
	 , NULL
	 , 'N'
	 );

SELECT * FROM EMPLOYEE WHERE EMP_ID = 223;
/*
 * 2) INSERT INTO 테이블명(컬럼명, 컬럼명, 컬럼명) VALUES(값, 값, 값);
 * => 테이블 특정 컬럼만 선택해서 컬럼에 값을 추가하면서 행을 추가할 때 사용
 * INSERT는 무조건 한 행 단위로 추가가 되기 때문에 작성하지 않는 컬럼은 NULL값이 들어감
 * 
 * 주의할 점 ) NOT NULL이 달려있는 컬럼은 반드시 테이블 명 뒤에 컬럼명을 적어야함
 * 예외 사항 ) NOT NULL제약조건이 달려있는데 기본값이 있는경우는 DEFAULT VALUE가 들어감
 */

INSERT
  INTO
  	   EMPLOYEE
  	   (
  	   EMP_ID
  	 , EMP_NAME
  	 , EMP_NO
  	 , JOB_CODE
  	 , SAL_LEVEL
  	   )
VALUES 
	   (
	   900
	 , '고길동'
	 , '770909-0909090'
	 , 'J5'
	 , 'S1'
	 );

SELECT * FROM EMPLOYEE;
--------------------------------------------------------------------------
/*
 * 3) INSERT INTO 테이블명 (서브쿼리);
 * => VALUES 대신에 서브쿼리를 작성해서 INSERT 할 수 있음
 */
-- 새 테이블 하나 만들기
CREATE TABLE EMP_01(
  EMP_NAME VARCHAR2(20),
  DEPT_TITLE VARCHAR2(20)
);
SELECT * FROM EMP_01;

-- EMPLOYEE 테이블에 존재하는 모든 사원 사원명과, 부서명을 새로만든 EMP_01에 INSERT
INSERT
  INTO
       EMP_01
       (
       SELECT
       	      EMP_NAME
       	    , DEPT_TITLE
       	 FROM
       	      EMPLOYEE
       	    , DEPARTMENT
       	WHERE
       		  DEPT_CODE = DEPT_ID(+)
       );
SELECT * FROM EMP_01;
------------------------------------------------------------------
/*
 * 4) INSERT ALL ☆★☆
 * 
 * 하나의 테이블에 여러 행을 한꺼번에 INSERT 할 때 사용 
 *  INSERT ALL
 *    INTO 테이블명 VALUES(값, 값, 값 ...)
 *    INTO 테이블명 VALUES(값, 값, 값 ...)
 *  SELECT *
 *    FROM DUAL;
 */

INSERT INTO EMP_01 VALUES('사원1', '부서1');
INSERT INTO EMP_01 VALUES('사원2', '부서2');

SELECT * FROM EMP_01;
INSERT INTO EMP_01 VALUES('사원3', '부서3');

INSERT
   ALL
       INTO EMP_01 VALUES('사원4', '부서4')
       INTO EMP_01 VALUES('사원5', '부서5')
       INTO EMP_01 VALUES('사원6', '부서6')
SELECT
	   *
  FROM
  	   DUAL;
---------------------------------------------------------------

/*
 * 2. UPDATE
 * 테이블에 기록된 기존의 데이터를 수정하는 구문
 * 
 *  [ 표현법 ]
 *  UPDATE
 * 		   테이블명
 *     SET
 * 	       컬럼명 = 바꿀값
 * 		 , 컬럼명 = 바꿀값
 *       , ... => 여러 개의 컬럼값을 바꿀 수 있음(, 써야함! AND아님!!)
 *   WHERE
 * 		   조건식; => 생략 가능
 */

-- 테이블 복사하기
CREATE TABLE DEPT_COPY2
	AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;

-- DEPT_COPY 테이블에서 총무부를 부서명을 미래사업부로 변경
UPDATE
	   DEPT_COPY
   SET
       DEPT_TITLE = '미래사업부';
SELECT * FROM DEPT_COPY;
-- 전체 행의 모든 DEPT_TITLE 컬럼 값이 전부 미래사업부로 UPDATE

ROLLBACK;

SELECT * FROM DEPT_COPY2;

UPDATE
	   DEPT_COPY2
   SET
   	   DEPT_TITLE = '미래사업부'
 WHERE
       DEPT_TITLE = '총무부';

SELECT * FROM DEPT_COPY2;

SELECT * FROM EMPLOYEE;
UPDATE 
	   EMPLOYEE
   SET
       SALARY = 100
 WHERE   
       EMP_ID = 204;

-- 전체 사원들 급여를 기존급여에서 5% 인상
UPDATE
	   EMPLOYEE
   SET
       SALARY = SALARY * 1.05;

SELECT * FROM EMPLOYEE;
--------------------------------------------------------------

/*
 * UPDATE 사용시 서브쿼리 사용해보기
 * 
 * UPDATE
 * 		  테이블명
 *    SET
 * 		  컬럼명 = (서브쿼리)
 *  WHERE
 * 	      조건;
 */
-- 안예성 사원의 급여를 김하늘 사원의 급여만큼으로 갱신
UPDATE
       EMPLOYEE
   SET
	   SALARY = (SELECT
	   				    SALARY
	   			   FROM
	   			   	    EMPLOYEE
	   			  WHERE
	   			  		EMP_NAME = '김하늘')
 WHERE
 	   EMP_ID = (SELECT
 	   				    EMP_ID
 	   			   FROM
 	   			        EMPLOYEE
 	   			  WHERE
 	   			  	    EMP_NAME = '안예성');
SELECT * FROM EMPLOYEE;
------------------------------------------------------------------

/*
 * 3. DELETE
 * 테이블에 기록된 행을 삭제하는 구문
 * 
 * [ 표현법 ]
 *  DELETE
 *    FROM
 * 		   테이블명
 *   WHERE
 * 	       조건; => 생략가능
 * WHERE 조건절을 작성하지 않으면 모든 행 삭제
 */
SELECT * FROM DEPT_COPY2;

DELETE
  FROM 
  	   DEPT_COPY2
 WHERE
 	   DEPT_TITLE = '미래사업부';

SELECT * FROM DEPT_COPY2;
-------------------------------------------------------

/*
 * * TRUNCATE : 테이블의 전체 행을 삭제하는 사용하는 구문(절삭)
 * 				DELETE보타 빠름(이론적으로)
 * 		        별도의 조건을 부여할 수 없음 ROLLBACK 불가능
 */

DELETE FROM DEPT_COPY; -- 0.005s
TRUNCATE TABLE DEPT_COPY2; -- 0.027s

-- 클래스와 객체
-- 클래스 : 객체를 생성하기 위한 템플릿 상태(필드), 행위(메서드) 정의함
-- 객체(인스턴스) : 클래스를 바탕으로 실제 메모리에 할당된 실체
-- 필드(멤버변수) : 객체의 데이터를 저장하는 변수
-- 메서드 : 객체가 수행할 수 있는 작업을 정의한 코드블럭
-- 생성자 : 객체를 생성할 때 사용하는 특수한 기능의 메소드
-- this : 


-- 상속
-- 개념 : 부모클래스의 특성(자료형, 필드, 메서드)을 자식클래스가 물려받는것
-- 목적 : 코드 재사용성 증가 , 계층적 관계 표현, 다형성 구현의 기반
-- 구현방법 : extends 키워드를 사용
-- super키워드 : 부모클래스의 객체주소를 담고있음
-- 메서드 오버라이딩 : 부모클래스의 메소드를 자식클래스에서 재정의
-- 제약사항 : 자바는 단일 상속만 지원
-- 모든 클래스는 Object클래스를 상속받아서 사용할 수 있음

-- 다형성
-- 정의 : 같은 자료형이지만 실행결과가 다양하게 객체를 이용할 수 있는 성질
-- UpCasting : 자식객체를 부모타입으로 참조해서 사용할 수 있는 성질(자동형변환)
-- DowunCasting : 부모 타입을 자식타입으로 사용해야 할 때 (강제 형변환이 필요)
-- MethodDispatch : 실행 시점에 객체의 실제 타입에 맞는 메소드가 호출됨 (동적 바인딩)

-- 캡슐화
-- 목적 : 객체의 속성과 행위를 하나로 묶고, 실제 구현내용을 외부로부터 감춤
-- 접근제어자 : private으로 필드를 선언
-- getter / setter : 필드에 접근하고 값을 변경하기 위한 메소드
-- 장점 : 코드 변경의 영향을 최소화, 유지보수 용이성, 객체 무결성을 유지

-- 추상화
-- 개념 : 공통적인 속성이나 기능을 추출하여 정의하는 것
-- 추상클래스 : abstact 키워드를 붙여서 선언
-- 목적 : 상속을 통한 확장을 염두해두고 설계 공통된 기능을 구현하고 자식 클래스마다의
-- 고유한 기능은 따로따로 오버라이딩해서 구현할 목적

-- 인터페이스
-- 정의 : 클래스들이 구현해야하는 메서드들의 집합을 정의
-- 인터페이스 상속 : 인터페이스가 다른 인터페이스를 상속 가능, 다중 구현도 가능
-- 마커 인터페이스 : 메서드가 없는 인터페이스(Serializable)
-- 함수형 인터페이스 : 단 하나의 추상메서드만을 가진 인터페이스(@FuntionalInterface)

-- 컬렉션 프레임워크
-- List : index개념이 있음, Value만 저장, 중복값 허용
-- Set : 순서를 보장하지 않음, index 개념이 없음, Value만 저장, 중복값 허용 x
-- Map : 키-값 쌍으로 저장, 순서를 보장해주지않음 (index개념이없음)
-- Collenction
-- Iterator : 컬렉션 요소를 순회하는 표준 방법

-- 예외처리

-- 예외처리
-- 예외(Exception) : 프로그램 실행 중 발생하는 예기치 않은 사건
-- CheckedException : 컴파일러가 처리를 강제함
-- UnCheckedException : 컴파일러가 처리를 강제하지 않음
-- Error : 코드로 해결이 안됨, 복구 불가능
-- 예외처리 구문 : try-catch, try-catch(multi-catch), try-catch-finally
--			   try-with-resources
-- 예외 전파 : throws키워드를 이용해서 메서드 호출 부 전달
--		   : throw 억지로 예외를 발생 시킬 수 있음


















