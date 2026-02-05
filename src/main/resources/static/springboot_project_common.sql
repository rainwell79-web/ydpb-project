-- 사용자 추가
CREATE USER sp
IDENTIFIED BY sp
DEFAULT TABLESPACE USERS
TEMPORARY TABLESPACE TEMP
QUOTA UNLIMITED ON USERS;

GRANT
    CREATE SESSION,
CREATE TABLE,
CREATE VIEW,
CREATE SEQUENCE,
CREATE PROCEDURE
    TO sp;

-- sp / sp
show user;

--------------------------------------------------------------------------------

-- 권한 테이블 삭제
drop table tbl_role;

-- 권한 테이블 생성
create table tbl_role(
                         role_id     number          primary key,
                         role_code   varchar2(20)    not null    check(role_code in ('user', 'admin', 'super_admin')),
                         role_name   varchar2(50)    not null    check(role_name in ('일반회원', '관리자', '최고관리자'))
);

select * from tbl_role;

-- 권한 테이블 기본값 설정
insert into tbl_role values(0, 'user', '일반회원');
insert into tbl_role values(1, 'admin', '관리자');
insert into tbl_role values(2, 'super_admin', '최고관리자');

commit;

--------------------------------------------------------------------------------

-- 회원정보 테이블 삭제
drop table tbl_member;

-- 회원정보 테이블 생성
create table tbl_member(
                           mem_id              varchar2(50)    primary key,
                           mem_password        varchar2(255)   not null,
                           mem_name            varchar2(100)   not null,
                           mem_type            varchar2(10)    check(mem_type in('NAVER', 'KAKAO', null)),
                           role_id             number          not null
                               constraint fk_member_role_id references tbl_role(role_id),
                           birth               varchar2(10),
                           gender              char(1)         check(gender in('M', 'F', null)),
                           address             varchar2(255)   not null,
                           address_detail      varchar2(255),
                           tel                 varchar2(20),
                           mobile              varchar2(20)    not null,
                           email               varchar2(100)   not null,
                           news_yn             number(1)       not null    check(news_yn in(0, 1)),
                           joined_at           date            default sysdate
);

-- 회원정보 목록
select * from tbl_member order by joined_at;

-- 회원정보 추가
insert into tbl_member(mem_id, mem_password, mem_name, mem_type, role_id, birth, gender, address, address_detail, tel, mobile, email, news_yn)
values('ceo', '1111', 'CEO', null, 2, null, null, '서울시 영등포구 영등포본동', null, null, '010-1111-1111', 'ceo@test.com', 1);
insert into tbl_member(mem_id, mem_password, mem_name, mem_type, role_id, birth, gender, address, address_detail, tel, mobile, email, news_yn)
values('test', '1111', 'tester', null, 0, null, null, '서울시 영등포구 영등포본동', null, null, '010-1111-1111', 'test@test.com', 1);
insert into tbl_member(mem_id, mem_password, mem_name, mem_type, role_id, birth, gender, address, address_detail, tel, mobile, email, news_yn)
values('admin', '1111', 'AD', null, 1, null, null, '서울시 영등포구 영등포본동', null, null, '010-1111-1111', 'admin@test.com', 1);

commit;

-- 로그인 확인
select * from tbl_member where mem_id = 'test' and mem_password = '1111';

-- 아이디 중복 확인
select count(*) from tbl_member where mem_id = 'test';

-- 회원 권한 확인
select r.role_code from tbl_member m inner join tbl_role r
                                                on m.mem_id = 'ceo' and m.role_id = r.role_id;

-- 회원정보 수정
update tbl_member
set birth = '2000-05-20', gender = 'M', address = '주소', address_detail = '상세주소', tel = '02-0000-1111', email = 'change@test.com', news_yn = 1
where mem_id = 'test';

-- 회원정보 인덱스 삭제
drop index idx_member_joined_at;

-- 회원정보 인덱스 생성
create index idx_member_joined_at on tbl_member(joined_at);

-- 회원정보 전체 글 개수
select count(*)
from tbl_member
where mem_id like '%s%' or mem_name like '%s%';

-- 회원정보 목록 조회 (검색+페이징)
select mem_id, mem_name, mem_type, mobile, email, joined_at
from (
         select mem_id, mem_name, mem_type, mobile, email, joined_at,
                row_number() over (order by joined_at desc) as rn
         from /*+ INDEX_DESC(tbl_member idx_member_joined_at) */
             tbl_member
     )
where rn between (1 - 1) * 10 + 1 and 1 * 10;

rollback;

--------------------------------------------------------------------------------

-- 우리동소식 테이블 삭제
drop table tbl_dongnews;

-- 우리동소식 시퀀스 삭제
drop sequence seq_ds;

-- 우리동소식 시퀀스 생성
create sequence seq_ds increment by 1 start with 1;

-- 우리동소식 테이블생성
create table tbl_dongnews(
                             bno             number          primary key,
                             bo_title        varchar2(255)   not null,
                             bo_content      varchar2(4000)  not null,
                             mem_id          varchar2(50)    not null
                                    constraint fk_dongnews_mem_id references tbl_member(mem_id),
                             dept_name       varchar2(100),
                             tel             varchar2(20),
                             hit             number          default 0   not null,
                             created_at      date            default sysdate,
                             updated_at      date
);

-- 우리동소식 더미데이터 1
insert into tbl_dongnews(bno, bo_title, bo_content, mem_id, dept_name, tel)
values(seq_ds.nextval, '제목', '내용', 'admin', '영등포본동', '02-2670-1025');

-- 우리동소식 목록
select * from tbl_dongnews order by bno desc;

-- 우리동소식 조회수 증가
update tbl_dongnews set hit = hit + 1 where bno = 1;

-- 우리동소식 조회
select * from tbl_dongnews where bno = 1;

-- 우리동소식 수정
update tbl_dongnews set bo_content = '내용 수정' where bno = 1;

rollback;

-- 우리동소식 더미 대량 추가
BEGIN
FOR i IN 1..25 LOOP
        insert into tbl_dongnews values(seq_ds.nextval, '우리동소식 ' || i, '내용', 'admin', '영등포본동', '02-2670-1026', 0, sysdate, null);
END LOOP;
END;
/

commit;

-- 인덱스 조회
select index_name from user_indexes where table_name = 'TBL_DONGNEWS';

-- 우리동소식 전체 글 개수
select count(*)
from tbl_dongnews
where bo_title like '%%' or bo_content like '%%';

-- 우리동소식 목록 (검색 + 페이징)
select bno, bo_title, dept_name, hit, created_at
from (
         select bno, bo_title, dept_name, hit, created_at,
                row_number() over (order by bno desc) as rn
         from /*+ INDEX_DESC(tbl_dongnews SYS_C007501) */
             tbl_dongnews
         where (bo_title like '%%' or bo_content like '%%')
     )
where rn between (1 - 1) * 10 + 1 and 1 * 10;

commit;

--------------------------------------------------------------------------------

-- 구청소식 테이블 삭제
drop table tbl_gunews;

-- 구청소식 시퀀스 삭제
drop sequence seq_gs;

-- 구청소식 시퀀스 생성
create sequence seq_gs increment by 1 start with 1;

-- 구청소식 테이블 생성
create table tbl_gunews(
                           bno             number          primary key,
                           bo_title        varchar2(255)   not null,
                           bo_content      varchar2(4000)  not null,
                           mem_id          varchar2(50)    not null
                                    constraint fk_gunews_mem_id references tbl_member(mem_id),
                           dept_name       varchar2(100),
                           tel             varchar2(20),
                           open_type       number(1)       not null    check(open_type in(0, 1)),
                           hit             number          default 0   not null,
                           created_at      date            default sysdate,
                           updated_at      date
);

-- 구청소식 등록
insert into tbl_gunews(bno, bo_title, bo_content, mem_id, dept_name, tel, open_type)
values(seq_gs.nextval, '제목', '내용', 'admin', '청년정책과', '02-0000-0000', 1);

-- 구청소식 목록
select * from tbl_gunews order by bno desc;

commit;

-- 구청소식 조회수 증가
update tbl_gunews set hit = hit + 1 where bno = 1;

-- 구청소식 조회
select * from tbl_gunews where bno = 1;

-- 구청소식 수정
update tbl_gunews set bo_content = '내용 수정' where bno = 1;

rollback;

-- 구청소식 더미 대량 추가
BEGIN
FOR i IN 1..25 LOOP
        insert into tbl_gunews values(seq_gs.nextval, '구청소식 ' || i, '내용', 'admin', '영등포본동', '02-2670-1026', mod(i, 2), 0, sysdate, null);
END LOOP;
END;
/

-- 구청소식 인덱스 조회
select index_name from user_indexes where table_name = 'TBL_GUNEWS';

-- 구청소식 전체 글 개수
select count(*)
from tbl_gunews
where bo_title like '%%' or bo_content like '%%';

-- 구청소식 목록 (검색 + 페이징)
select bno, bo_title, dept_name, hit, created_at
from (
         select bno, bo_title, dept_name, hit, created_at,
                row_number() over (order by bno desc) as rn
         from /*+ INDEX_DESC(tbl_gunews SYS_C007516) */
             tbl_gunews
         where (bo_title like '%%' or bo_content like '%%')
     )
where rn between (1 - 1) * 10 + 1 and 1 * 10;

commit;

--------------------------------------------------------------------------------

-- 포토갤러리 테이블 삭제
drop table tbl_gallery;

-- 포토갤러리 시퀀스 삭제
drop sequence seq_gy;

-- 포토갤러리 시퀀스 생성
create sequence seq_gy increment by 1 start with 1;

-- 포토갤러리 테이블 생성
create table tbl_gallery(
                            bno             number          primary key,
                            bo_title        varchar2(255)   not null,
                            bo_content      varchar2(4000)  not null,
                            mem_id          varchar2(50)    not null
                                    constraint fk_gallery_mem_id references tbl_member(mem_id),
                            dept_name       varchar2(100),
                            tel             varchar2(20),
                            hit             number          default 0   not null,
                            created_at      date            default sysdate,
                            updated_at      date
);

-- 포토갤러리 등록
insert into tbl_gallery(bno, bo_title, bo_content, mem_id, dept_name, tel)
values(seq_gy.nextval, '제목', '내용', 'admin', '영등포본동', '02-2670-1026');

-- 포토갤러리 목록
select * from tbl_gallery order by bno desc;

commit;

-- 포토갤러리 조회수 증가
update tbl_gallery set hit = hit + 1 where bno = 1;

-- 포토갤러리 조회
select * from tbl_gallery where gy_no = 1;

-- 포토갤러리 수정
update tbl_gallery set bo_content = '내용 수정' where bno = 1;

rollback;

-- 포토갤러리 더미 대량 추가
BEGIN
FOR i IN 1..25 LOOP
        insert into tbl_gallery values(seq_gy.nextval, '포토갤러리 ' || i, '내용', 'admin', '영등포본동', '02-2670-1026', 0, sysdate, null);
END LOOP;
END;
/

-- 포토갤러리 인덱스 조회
select index_name from user_indexes where table_name = 'TBL_GALLERY';

-- 포토갤러리 전체 글 개수
select count(*)
from tbl_gallery
where bo_title like '%%' or bo_content like '%%';

-- 포토갤러리 목록 (검색 + 페이징)
select bno, bo_title, hit, created_at
from (
         select bno, bo_title, hit, created_at,
                row_number() over (order by bno desc) as rn
         from /*+ INDEX_DESC(tbl_gallery SYS_C007528) */
             tbl_gallery
         where bo_title like '%%' or bo_content like '%%'
     )
where rn between (1 - 1) * 10 + 1 and 1 * 10;

commit;

--------------------------------------------------------------------------------

-- 주민제안 테이블 삭제
drop table tbl_proposal;

-- 주민제안 시퀀스 삭제
drop sequence seq_pl;

-- 주민제안 시퀀스 생성
create sequence seq_pl increment by 1 start with 1;

-- 주민제안 테이블 생성
create table tbl_proposal(
                             bno             number      primary key,
                             bo_title        varchar2(255)   not null,
                             bo_content      varchar2(4000)  not null,
                             mem_id          varchar2(50)    not null
                                    constraint fk_proposal_mem_id references tbl_member(mem_id),
                             problem         varchar2(4000)  not null,
                             effect          varchar2(4000)  not null,
                             public_yn       number(1)       not null    check(public_yn in(0, 1)),
                             hit             number          default 0   not null,
                             created_at      date            default sysdate,
                             updated_at      date
);

-- 주민제안 더미데이터 1
insert into tbl_proposal()
values(seq_pl.nextval, '제목', '개선방안', 'test', '문제점', '효과', 1, 0);

-- 주민제안 목록
select * from tbl_proposal order by bno desc;

commit;

-- 주민제안 등록
insert into tbl_proposal(bno, bo_title, problem, bo_content, effect, pl_public, mem_id)
values(seq_pl.nextval, '제안제목', '현황 및 문제점', '제안내용', '기대효과', 'Y', 'test');

-- 주민제안 조회
select * from tbl_proposal where bno = 1;

-- 주민제안 수정
update tbl_proposal set bo_title = '제목 수정', problem = '문제점 수정', bo_content = '내용 수정', effect = '효과 수정', pl_public = 'Y' where bno = 1;
update tbl_proposal set pl_public = 'N' where bno = 20;

-- 주민제안 삭제
delete from tbl_proposal where bno = 1;

rollback;

-- 주민제안 더미 대량 추가
BEGIN
FOR i IN 1..25 LOOP
        insert into tbl_proposal values(seq_pl.nextval, '주민제안' || i, '현황 및 문제점', '제안내용', '기대효과', 'Y', null, null, 0, sysdate, 'test');
END LOOP;
END;
/

-- 주민제안 인덱스 조회
select index_name from user_indexes where table_name = 'TBL_PROPOSAL';

-- 주민제안 전체 글 개수
select count(*)
from tbl_proposal
where bo_title like '%%' or bo_content like '%%';

-- 주민제안 목록 (검색 + 페이징)
select bno, bo_title, pl_public, status, reg_date, mem_id
from (
         select bno, bo_title, pl_public, status, reg_date, mem_id,
                row_number() over (order by bno desc) as rn
         from /*+ INDEX_DESC(tbl_proposal SYS_C007265) */
             tbl_proposal
         where bo_title like '%%' or bo_content like '%%'
     )
where rn between (1 - 1) * 10 + 1 and 1 * 10;

commit;

-- 주민제안 파일 테이블 삭제
drop table tbl_proposal_flies;

-- 주민제안 파일 시퀀스 삭제
drop sequence seq_pl_files;

-- 주민제안 파일 시퀀스 생성
create sequence seq_pl_files increment by 1 start with 1;

-- 주민제안 파일 테이블 생성
create table tbl_proposal_flies(
                                   file_id     number  primary key,
                                   file_name   varchar2(255),
                                   file_path   varchar2(255),
                                   file_alt    varchar2(255),
                                   bno         number
                                       constraint fk_proposal_file references tbl_proposal(bno)
);

-- 주민제안 파일 테이블 조회
select * from tbl_proposal_flies;

-- 주민제안 파일 더미데이터
insert into tbl_proposal_flies
values(seq_pl_files.nextval, 'dummy_img_01.png', null, 26);

-- 주민제안 파일 조회
select * from tbl_proposal_flies where bno = 1 order by file_id;

commit;

--------------------------------------------------------------------------------

-- 자치회관 게시판 테이블 삭제
drop table tbl_community;

-- 자치회관 게시판 시퀀스 삭제
drop sequence seq_cy;

-- 자치회관 게시판 시퀀스 생성
create sequence seq_cy increment by 1 start with 1;

-- 자치회관 게시판 테이블 생성
create table tbl_community(
                              bno         number          primary key,
                              bo_title    varchar2(255)   not null,
                              bo_content  varchar2(4000)  not null,
                              dept_name   varchar2(100),
                              dong_name   varchar2(100),
                              hit         number          default 0,
                              reg_date     Date            default sysdate
);

-- 자치회관 게시판 더미데이터 1
insert into tbl_community values(seq_cy.nextval, '영등포본동 자치회관 운영세칙',
                                 '영등포본동 자치회관 운영세칙',
                                 '영등포본동', '영등포본동', 100, sysdate);

-- 자치회관 게시판 목록
select * from tbl_community order by bno desc;

commit;

-- 자치회관 게시판 조회수 증가
update tbl_community set hit = hit + 1 where bno = 1;

-- 자치회관 게시판 조회
select * from tbl_community where bno = 1;

-- 자치회관 게시판 수정
update tbl_community set dept_name = null where bno = 21;

rollback;

-- 자치회관 게시판 더미 대량 추가
BEGIN
FOR i IN 1..25 LOOP
        insert into tbl_community values(seq_cy.nextval, '자치회관 게시판' || i, '내용', '영등포본동', '영등포본동', 0, sysdate);
END LOOP;
END;
/

-- 자치회관 인덱스 조회
select index_name from user_indexes where table_name = 'TBL_COMMUNITY';

-- 자치회관 전체 글 개수
select count(*)
from tbl_community
where bo_title like '%%' or bo_content like '%%';

-- 자치회관 목록 (검색 + 페이징)
select bno, bo_title, dept_name, hit, reg_date
from (
         select bno, bo_title, dept_name, hit, reg_date,
                row_number() over (order by bno desc) as rn
         from /*+ INDEX_DESC(tbl_community SYS_C007250) */
             tbl_community
         where bo_title like '%%' or bo_content like '%%'
     )
where rn between (1 - 1) * 10 + 1 and 1 * 10;

commit;

-- 자치회관 게시판 파일 테이블 삭제
drop table tbl_community_flies;

-- 자치회관 게시판 파일 시퀀스 삭제
drop sequence seq_cy_files;

-- 자치회관 게시판 파일 시퀀스 생성
create sequence seq_cy_files increment by 1 start with 1;

-- 자치회관 게시판 파일 테이블 생성
create table tbl_community_flies(
                                    file_id     number  primary key,
                                    file_name   varchar2(255),
                                    file_path   varchar2(255),
                                    file_alt    varchar2(255),
                                    bno         number
                                        constraint fk_community_file references tbl_community(bno)
);

-- 자치회관 게시판 파일 테이블 조회
select * from tbl_community_flies;

-- 자치회관 게시판 파일 더미데이터
insert into tbl_community_flies
values(seq_cy_files.nextval, 'dummy_xlsx.xlsx', null, 26);

-- 자치회관 게시판 파일 조회
select * from tbl_community_flies where bno = 1 order by file_id;

commit;

--------------------------------------------------------------------------------

-- 파일 테이블 삭제
drop table tbl_files;

-- 파일 테이블 시퀀스 삭제
drop sequence seq_files;

-- 파일 테이블 시퀀스 생성
create sequence seq_files increment by 1 start with 1;

-- 파일 테이블 생성
create table tbl_files (
                           file_id     number          primary key,
                           uuid        varchar2(100),
                           file_name   varchar2(255),
                           file_path   varchar2(255),
                           file_alt    varchar2(255),
                           insert_yn   number(1)       default 0   not null    check(insert_yn in(0, 1)),
                           board_type  varchar2(100)   not null,
                           bno         number          not null
);

-- 파일 테이블 조회
select * from tbl_files;

-- 특정 게시물의 파일 조회
select * from tbl_files where board_type = 'TBL_DONGNEWS' and bno = 1 order by file_id;

commit;