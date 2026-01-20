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

-- 회원정보 테이블 삭제
drop table tbl_member;

-- 회원정보 테이블 생성
create table tbl_member(
    mem_id              varchar2(40)    primary key,
    mem_name            varchar2(60)    not null,
    birth               varchar2(10),
    gender              char(1)         check(gender in('M', 'F', null)),
    mem_password        varchar2(255)   not null,
    address             varchar2(200)   not null,
    address_detail      varchar2(300),
    tel                 varchar2(20),
    mobile              varchar2(20)    not null,
    email               varchar2(100)   not null,
    news_yn             char(1)     not null            check(news_yn in('Y', 'N')),
    regdate             Date            default sysdate
);

-- 회원정보 목록
select * from tbl_member;

-- 회원정보 추가
insert into tbl_member(mem_id, mem_name, birth, gender, mem_password, address, address_detail, tel, mobile, email, news_yn) 
values('test', 'tester', null, null, '1111', '서울시 영등포구 영등포본동', null, null, '010-1111-1111', 'test@test.com', 'Y');

commit;

-- 로그인 확인
select * from tbl_member where mem_id = 'test' and mem_password = '1111';

-- 아이디 중복 확인
select count(*) from tbl_member where mem_id = 'test';

-- 회원정보 인덱스 삭제
drop index idx_member_regdate;

-- 회원정보 인덱스 생성
create index idx_member_regdate on tbl_member(regdate);

-- 회원정보 전체 글 개수
select count(*)
from tbl_member
where mem_id like '%s%' or mem_name like '%s%';

-- 회원정보 목록 조회 (검색+페이징)
select mem_id, mem_name, birth, gender, tel, mobile, email, regdate
from (
    select mem_id, mem_name, birth, gender, tel, mobile, email, regdate,
        row_number() over (order by regdate desc) as rn
    from /*+ INDEX_DESC(tbl_member idx_member_regdate) */
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
    bo_title        varchar2(300)   not null,
    bo_content      varchar2(4000)  not null,
    dept_name       varchar2(100),
    tel             varchar2(20),
    hit             number          default 0   not null,
    regdate         date            default sysdate
);

-- 우리동소식 더미데이터 1
insert into tbl_dongnews values(seq_ds.nextval, '남북 이산가족 공연 안내',
'남북 이산가족 공연 안내', 
'영등포본동', '02-2670-1025', 42, sysdate);

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
        insert into tbl_dongnews values(seq_ds.nextval, '우리동소식 ' || i, '내용', '영등포본동', '02-2670-1026', 0, sysdate);
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
select bno, bo_title, dept_name, hit, regdate
from (
    select bno, bo_title, dept_name, hit, regdate,
        row_number() over (order by bno desc) as rn
    from /*+ INDEX_DESC(tbl_dongnews SYS_C007218) */
        tbl_dongnews
    where (bo_title like '%%' or bo_content like '%%')
)
where rn between (1 - 1) * 10 + 1 and 1 * 10;

commit;

-- 우리동소식 파일 테이블 삭제
drop table tbl_dongnews_flies;

-- 우리동소식 파일 시퀀스 삭제
drop sequence seq_ds_files;

-- 우리동소식 파일 시퀀스 생성
create sequence seq_ds_files increment by 1 start with 1;

-- 우리동소식 파일 테이블 생성
create table tbl_dongnews_flies(
    file_id     number  primary key,
    file_name   varchar2(255),
    file_path   varchar2(255),
    bno         number
                constraint fk_dongnews_file references tbl_dongnews(bno)
);

-- 우리동소식 파일 테이블 조회
select * from tbl_dongnews_flies;

-- 우리동소식 파일 더미데이터
insert into tbl_dongnews_flies 
values(seq_ds_files.nextval, 'dummy_xlsx.xlsx', null, 25);

-- 우리동소식 파일 조회
select * from tbl_dongnews_flies where bno = 21 order by file_id;

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
    bo_title        varchar2(300)   not null,
    bo_content      varchar2(4000)  not null,
    dept_name       varchar2(100),
    tel             varchar2(20),
    hit             number          default 0   not null,
    nuri            char(1)         not null        check(nuri in('Y', 'N')),
    regdate         date            default sysdate
);

-- 구청소식 더미데이터 1
insert into tbl_gunews values(seq_gs.nextval, '영등포 청년 네이버 카페 레벨업 이벤트',
'영등포구 공식 카페영등포 청년 네이버 카페에서 2026년 가입 신규회원 대상으로 이벤트를 엽니다.

신규 가입  후 등업하면 경품이 팡팡팡~ 등급이 올라갈수록 쑥쑥 커지는 경품!

이벤트 내용: 영등포 청년 네이버 카페 신규 가입 후 카페 활동으로 등급 UP → 추첨을 통해 경품 지급
참여대상: 2026년 영등포 청년 네이버 카페 신규 가입 회원(2026. 1. 1. 기준)
이벤트 기간: 2026. 1. 6.(화) ~ 2. 18.(수)',
'청년정책과',
'02-2670-1662', 300, 'Y', sysdate);

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
        insert into tbl_gunews values(seq_gs.nextval, '구청소식 ' || i, '내용', '영등포본동', '02-2670-1026', 100, 'Y', sysdate);
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
select bno, bo_title, dept_name, hit, regdate
from (
    select bno, bo_title, dept_name, hit, regdate,
        row_number() over (order by bno desc) as rn
    from /*+ INDEX_DESC(tbl_gunews SYS_C007226) */
        tbl_gunews
    where (bo_title like '%%' or bo_content like '%%')
)
where rn between (1 - 1) * 10 + 1 and 1 * 10;

commit;

-- 구청소식 파일 테이블 삭제
drop table tbl_gunews_flies;

-- 구청소식 파일 시퀀스 삭제
drop sequence seq_gs_files;

-- 구청소식 파일 시퀀스 생성
create sequence seq_gs_files increment by 1 start with 1;

-- 구청소식 파일 테이블 생성
create table tbl_gunews_flies(
    file_id     number  primary key,
    file_name   varchar2(255),
    file_path   varchar2(255),
    bno         number
                constraint fk_gunews_file references tbl_gunews(bno)
);

-- 우리동소식 파일 테이블 조회
select * from tbl_gunews_flies;

-- 우리동소식 파일 더미데이터
insert into tbl_gunews_flies 
values(seq_gs_files.nextval, 'dummy_pdf.pdf', null, 25);

-- 우리동소식 파일 조회
select * from tbl_gunews_flies where bno = 1 order by file_id;

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
    bno         number          primary key,
    bo_title    varchar2(300)   not null,
    bo_content  varchar2(4000)  not null,
    dept_name   varchar2(100),
    tel         varchar2(20),
    hit         number          default 0,
    regdate     Date            default sysdate
);

-- 포토갤러리 등록
insert into tbl_gallery values(seq_gy.nextval, '(10/16) 주민자치위원회 10월 정기회의 개최',
'주민자치위원회 정기회의 개최',
'영등포본동',
'02-2670-1026', 80, sysdate);

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
        insert into tbl_gallery values(seq_gy.nextval, '포토갤러리 ' || i, '내용', '영등포본동', '02-2670-1026', 0, sysdate);
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
select bno, bo_title, hit, regdate
from (
    select bno, bo_title, hit, regdate,
        row_number() over (order by bno desc) as rn
    from /*+ INDEX_DESC(tbl_gallery SYS_C007235) */
        tbl_gallery
    where bo_title like '%%' or bo_content like '%%'
)
where rn between (1 - 1) * 10 + 1 and 1 * 10;

commit;

-- 포토갤러리 파일 테이블 삭제
drop table tbl_gallery_flies;

-- 포토갤러리 파일 시퀀스 삭제
drop sequence seq_gy_files;

-- 포토갤러리 파일 시퀀스 생성
create sequence seq_gy_files increment by 1 start with 1;

-- 포토갤러리 파일 테이블 생성
create table tbl_gallery_flies(
    file_id     number  primary key,
    file_name   varchar2(255),
    file_path   varchar2(255),
    bno         number
                constraint fk_gallery_file references tbl_gallery(bno)
);

-- 포토갤러리 파일 테이블 조회
select * from tbl_gallery_flies;

-- 포토갤러리 파일 더미데이터
insert into tbl_gallery_flies 
values(seq_gy_files.nextval, 'gallery_img_02.jpg', null, 26);

-- 포토갤러리 파일 조회
select * from tbl_gallery_flies where bno = 1 order by file_id;

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
    bno         number      primary key,
    bo_title    varchar2(300)   not null,
    problem     varchar2(4000)  not null,
    bo_content  varchar2(4000)  not null,
    effect      varchar2(4000)  not null,
    pl_public   char(1)         not null    check(pl_public in('Y', 'N')),
    status      varchar2(20)    check(status in('완료', '진행중', '민원이첩')),
    opinion     varchar2(4000),
    hit         number          default 0,
    regdate     Date            default sysdate,
    mem_id      varchar2(40)    not null    constraint fk_pl_mem_id references tbl_member(mem_id)
);

-- 주민제안 더미데이터 1
insert into tbl_proposal values(seq_pl.nextval, '지하철역 미화개선',
'구로디지탈단지역 계단이 미끄럽고 보기에 너무 안 좋습니다
원광디지털대학교-지밸리로 이어지는 인도 바로 옆에 도로라 우천, 폭설시 너무 위험합니다',
'봄이 오면 안전 보안 및 미화 개선 바랍니다',
'거주 주민의 안전과 행복 상승',
'Y', '완료',
'안녕하십니까? 영등포구청 구민제안 담당자입니다.
귀하께서 제출해주신 ＇지하철역 미화개선＇건 관련하여
구로디지털단지역 민원 내용은 서울시 구로구 홈페이지에 문의주시기 바랍니다.
(구홈페이지 제안건은 타기관 이송이 안되는 점 양해부탁드립니다.)

이에 「영등포구 제안제도 운영 조례」 제2조 제1호 사목(서울특별시 영등포구의 사무에 관한 사항이 아닌 것) 등에 따라 비제안 처리하고자 합니다.
우리 구 발전을 위한 소중한 의견 감사드립니다.', 0, sysdate, 'test');

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
select bno, bo_title, pl_public, status, regdate, mem_id
from (
    select bno, bo_title, pl_public, status, regdate, mem_id,
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
    bo_title    varchar2(300)   not null,
    bo_content  varchar2(4000)  not null,
    dept_name   varchar2(100),
    dong_name   varchar2(100),
    hit         number          default 0,
    regdate     Date            default sysdate
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
select bno, bo_title, dept_name, hit, regdate
from (
    select bno, bo_title, dept_name, hit, regdate,
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
