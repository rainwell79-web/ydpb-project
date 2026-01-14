-- hr / hr
show user;

--------------------------------------------------------------------------------

-- 회원정보 테이블 삭제
drop table tbl_member;

-- 회원정보 테이블 생성
create table tbl_member(
    mem_id                  varchar2(40)    primary key,
    mem_name                varchar2(60)    not null,
    mem_birth               varchar2(10),
    mem_gender              varchar2(10)    check(mem_gender in('남자', '여자')),
    mem_password            varchar2(20)    not null,
    mem_address             varchar2(200)   not null,
    mem_address_detail      varchar2(300),
    mem_tel                 varchar2(13),
    mem_mobile              varchar2(13)    not null,
    mem_email               varchar2(100)   not null,
    mem_news                varchar2(2)     not null            check(mem_news in('Y', 'N')),
    mem_regdate             Date            default sysdate
);

-- 회원정보 목록
select * from tbl_member;

-- 회원정보 추가
insert into tbl_member(mem_id, mem_name, mem_birth, mem_gender, mem_password, mem_address, mem_address_detail, mem_tel, mem_mobile, mem_email, mem_news) values('test', 'tester', null, null, '1111', '서울시 영등포구 영등포본동', null, null, '010-1111-1111', 'test@test.com', 'Y');
insert into tbl_member(mem_id, mem_name, mem_birth, mem_gender, mem_password, mem_address, mem_address_detail, mem_tel, mem_mobile, mem_email, mem_news) values('csl2', 'csl', null, '남자', '1111', '서울시 영등포구 영등포본동', '영등포본동아파트', null, '010-1234-5678', 'csl@test.com', 'Y');
    
commit;

-- 로그인 확인
select * from tbl_member where mem_id = 'test' and mem_password = '1111';

-- 아이디 중복 확인
select count(*) from tbl_member where mem_id = 'test';

-- 인덱스 삭제
drop index idx_member_reg_date;

-- 인덱스 생성
create index idx_member_reg_date on tbl_member(mem_regdate);

-- 인덱스명 조회
SELECT index_name, column_name, column_position FROM user_ind_columns WHERE table_name = 'TBL_MEMBER';

-- 회원정보 목록 조회 (검색+페이징)
select 
    mem_id, mem_name, mem_birth, mem_gender, mem_password, mem_address, mem_address_detail, mem_tel, mem_mobile, mem_email, mem_news, mem_regdate
from (
    select /*+INDEX_DESC(tbl_member idx_member_reg_date) */
        rownum rn, mem_id, mem_name, mem_birth, mem_gender, mem_password, mem_address, mem_address_detail, mem_tel, mem_mobile, mem_email, mem_news, mem_regdate
    from 
        tbl_member
    where (
        mem_id like '%%' or
        mem_name like '%%'
    ) and
--        rownum <= #{pageNum} * #{amount}
        rownum <= 1 * 10
)
--where rn > (#{pageNum} -1) * #{amount};
where rn > (1 - 1) * 10;

select *
from (
    select /*+INDEX_DESC(tbl_member idx_member_reg_date) */
        mem_id, mem_name, mem_birth, mem_gender, mem_password, mem_address, mem_address_detail, mem_tel, mem_mobile, mem_email, mem_news, mem_regdate,
        ROW_NUMBER() over (order by mem_regdate desc) as rn
    from tbl_member
    where mem_id like '%%' or mem_name like '%%'
)
where rn > (1 - 1) * 10 and rn <= 1 * 10;

rollback;

--------------------------------------------------------------------------------

-- 주민제안 테이블 삭제
drop table tbl_proposal;

-- 주민제안 시퀀스 삭제
drop sequence seq_pl;

-- 주민제안 시퀀스 생성
create sequence seq_pl increment by 1 start with 1;

-- 주민제안 테이블 생성
create table tbl_proposal(
    pl_no           number(10)      primary key,
    pl_title        varchar2(300)   not null,
    pl_problem      varchar2(4000)  not null,
    pl_content      varchar2(4000)  not null,
    pl_effect       varchar2(4000)  not null,
    pl_public       varchar2(2)     not null    check(pl_public in('Y', 'N')),
    pl_handle       varchar2(20)    check(pl_handle in('완료', '진행중', '민원이첩')),
    pl_opinion      varchar2(4000),
    pl_regdate      Date            default sysdate,
    mem_id          varchar2(20)    constraint fk_pl_id references tbl_member(mem_id)
);

-- 주민제안 목록
select * from tbl_proposal order by pl_no desc;

-- 주민제안 더미데이터 1
insert into tbl_proposal values(seq_pl.nextval, '지하철역 미화개선',
'구로디지탈단지역 계단이 미끄럽고 보기에 너무 안 좋습니다
녹슨 계단 사진을 찍었는데 첨부가 안되네요
원광디지털대학교-지밸리로 이어지는 인도 바로 옆에 도로라 우천, 폭설시 너무 위험합니다',
'봄이 오면 안전 보안 및 미화 개선 바랍니다',
'거주 주민의 안전과 행복 상승',
'Y', '완료',
'안녕하십니까? 영등포구청 구민제안 담당자입니다.
귀하께서 제출해주신 ＇지하철역 미화개선＇건 관련하여
구로디지털단지역 민원 내용은 서울시 구로구 홈페이지에 문의주시기 바랍니다.
(구홈페이지 제안건은 타기관 이송이 안되는 점 양해부탁드립니다.)

이에 「영등포구 제안제도 운영 조례」 제2조 제1호 사목(서울특별시 영등포구의 사무에 관한 사항이 아닌 것) 등에 따라 비제안 처리하고자 합니다.
우리 구 발전을 위한 소중한 의견 감사드립니다.', sysdate, 'test');

-- 주민제안 더미데이터 2
insert into tbl_proposal(pl_no, pl_title, pl_problem, pl_content, pl_effect, pl_public, mem_id)
values(seq_pl.nextval, '신안산선 연계 영등포 남북 통합 보행축 조성 및 육교 환경 개선',
'보행 네트워크의 단절: 현재 영등포역 인근은 대규모 철도 노선으로 인해 남북 지역이 물리적으로 단절되어 있으며, 기존 영등포푸르지오 앞 육교가 유일한 통로 역할을 하고 있으나 쪽방촌, 공업소, 집장촌과의 연결로 인하여 그 사용율이 현저이 떨어짐.

신안산선 출구 계획의 국소성: 신안산선 영등포역 출구의 환승이 영등포역 북측에 출구가 생겨 기찻길 위로 보조 육교형태로 영등포역과 환승통로로 연결될 예정이나, 이것이 기존 육교와 분리될 경우 보행 동선이 중복되거나 파편화될 우려가 있음.

시설 노후화 및 미관 저해: 기존 육교는 설치된 지 오래되어 계단이 노후화되고 엘레베이터 고장 문제 등 많은 문제가 발생하고 있음. 특히 육교 전체가 낡은 철조망으로 뒤덮여 있어 감옥 같은 삭막한 분위기를 조성하고 도심 미관을 크게 훼손함.

안전 및 편의성 부족: 야간 조도 부족으로 인한 범죄 우려와 노후 엘리베이터의 잦은 고장으로 교통약자(고령자, 유모차 이용객 등)의 이동권이 침해받고 있음.',
'신안산선-기존 육교의 직통 연결: 신안산선 영등포역 상부 연결 통로와 기존 영등포푸르지오 앞 육교를 유기적으로 잇는 ＇통합 보행 데크＇ 구축을 검토하여 남북을 관통하는 직주근접형 보행축 형성. (영등포역과 영등포푸르지오 앞 육교

육교 환경의 전면적 현대화:
1) 철조망 철거: 기존의 흉물스러운 철조망을 즉시 제거하고, 투명 강화유리 또는 디자인 펜스로 교체하여 개방감 확보.
2) 시설 리모델링: 노후 바닥재 전면 교체, 내부 도색, 비가림 캐노피 설치 및 야간 경관 조명(LED) 도입.
3) 이동 편의 시설 확충: 교통약자를 위한 고성능 엘리베이터 교체 및 보행로 평탄화 작업 실시.',
'지역 통합 및 접근성 향상: 신안산선 출구와 육교의 직통 연결을 통해 영등포 남북 지역 간 이동 시간을 단축하고, 지하철 이용 편의성을 극대화하여 지역 경제 활성화에 기여.

도시 미관 개선 및 자부심 고취: 낡고 위험해 보이던 육교를 현대적 랜드마크 보행로로 탈바꿈시켜 주변 주거 환경 개선 및 구민들의 정주 의식 제고.

보행자 안전 확보: 노후 시설 정비와 조명 확충을 통해 안전사고를 미연에 방지하고, 야간에도 안심하고 걸을 수 있는 보행 환경 조성.', 'N', 'test');

-- 주민제안 더미데이터 3
insert into tbl_proposal(pl_no, pl_title, pl_problem, pl_content, pl_effect, pl_public, mem_id)
values(seq_pl.nextval, '도로표지판 수정 요청합니다',
'오목교 건너기 전(문래동) 사거리 교통표지판이 도로 이용상황을 반영하고 있지 못함
2개의 차선 중 1차로는 좌회전, 2차로는 직진으로 오랫동안 이용되어 오다 병목현상으로 인해 교통정체가 가중되자 올해 들어 2차로도 좌회전, 직진이 가능하도록 도로에 표시를 해놓았고 네비게이션에도 업데이트되어 반영되어 있음
그런데 사거리 표지판에는 예전의 도로교통 이용상황만 반영되어 있어 변경된 상황을 인지하지 못한 운전자들은 2차로에서 좌회전하는 것이 불법이라고 오인하여 좌회전하면서 차선을 2차로로 급하게 변경하여 사고를 유발하게 되고 클락션을 울리는 경우도 많음. 오랜시간동안 시정이 되지 않아 기다리다 지쳐 민원 올립니다
현재 적용되고 있는 교통 안내 도로를 표지판에 반영되고 있지 않아 교통이 혼잡한 시간대 정체 현상 및 교통사고의 우려가 큼',
'사거리 교통 표지판 업데이트',
'병목현상으로 인한 도로정체 해소, 교통사고 우려 감소', 'Y', 'test');

commit;

-- 주민제안 등록
insert into tbl_proposal(pl_no, pl_title, pl_problem, pl_content, pl_effect, pl_public, mem_id)
values(seq_pl.nextval, '제안제목', '현황 및 문제점', '제안내용', '기대효과', 'Y', 'test');

-- 주민제안 목록
select * from tbl_proposal order by pl_no desc;

-- 주민제안 조회
select * from tbl_proposal where pl_no = 3;

-- 주민제안 수정
update tbl_proposal set pl_title = '제목 수정', pl_problem = '문제점 수정', pl_content = '내용 수정', pl_effect = '효과 수정', pl_public = 'Y' where pl_no = 3;

-- 주민제안 삭제
delete from tbl_proposal where pl_no = 3;

rollback;

-- 주민제안 시퀀스 삭제 및 재생성
select seq_pl.currval from dual;
drop sequence seq_pl;
create sequence seq_pl increment by 1 start with 3;

-- 주민제안 목록 최종
select * from (select A.* ,Rownum Rnum from (select * from tbl_proposal 
where pl_title like '%%' 
order by pl_no desc)A) where Rnum > (1 - 1) * 10 and Rnum <= 1 * 10;

--------------------------------------------------------------------------------

-- 우리동소식 테이블 삭제
drop table tbl_dongnews;

-- 우리동소식 시퀀스 삭제
drop sequence seq_ds;

-- 우리동소식 시퀀스 생성
create sequence seq_ds increment by 1 start with 1;

-- 우리동소식 테이블생성
create table tbl_dongnews(
    ds_no           number(10)      primary key,
    ds_title        varchar2(300)   not null,
    ds_content      varchar2(4000)  not null,
    ds_depart       varchar2(100),
    ds_tel          varchar2(13),
    ds_hit          number(10)      default 0,
    ds_files        varchar2(1000),
    ds_regdate      Date            default sysdate
);

-- 우리동소식 더미데이터 1
insert into tbl_dongnews values(seq_ds.nextval, '남북 이산가족 공연 안내',
'남북 이산가족 공연 안내', 
'영등포본동', '02-2670-1025', 42, 'dummy_pdf.pdf', sysdate);

-- 우리동소식 더미데이터 2
insert into tbl_dongnews values(seq_ds.nextval, '2025년 농림어업총조사 실시',
'□ 2025 농림어업총조사 개요
❍ 조사 대상: 조사 기준 시점(2025.12.1. 0시) 현재 조사 대상 지역 내의 모든 농가· 임가·어가(해수면, 내수면)와 행정리
❍ 조사 기간: ‘25.11.20.(목) ~ 12.22.(월)
- 인터넷조사: 11.20.(목) ~ 12.10.(수)
- 방문면접조사: 12.1.(월) ~ 12.22.(월)
※ 인터넷조사 미완료 가구를 대상으로 방문면접조사 실시(12.10.까지 인터넷조사 가능)
❍ 조사 항목 : 농가·임가 58개, 해수면 30개, 내수면 30개
❍ 문 의 : 농림어업총조사 콜센터(☎080-360-2025)
영등포구 농림어업총조사 통계상황실(☎02-3457-7050)',
'영등포본동', '02-2670-1026', 35, 'dummy_img_01.jpg,dummy_img_02.jpg', sysdate);

-- 우리동소식 더미데이터 3
insert into tbl_dongnews values(seq_ds.nextval, '작은도서관 자원봉사자 모집 안내', 
'영등포본동 작은도서관: 월~금 근무
청소년문화의집 작은도서관: 화~토 근무', 
'영등포본동', '02-2670-1026', 12, 'dummy_img_01.png', sysdate);

-- 우리동소식 목록
select * from tbl_dongnews order by ds_no desc;

commit;

-- 우리동소식 더미데이터 탬플릿
insert into tbl_dongnews values(seq_ds.nextval, '제목',
'내용',
'영등포본동', '02-2670-1026', 30, 'dummy_img_01.jpg', sysdate);

-- 우리동소식 수정 (테스트용)
update tbl_dongnews set ds_files = 'dummy_img_01.png' where ds_no = 3;

-- 우리동소식 조회수 증가
update tbl_dongnews set ds_hit = ds_hit + 1 where ds_no = 3;

-- 우리동소식 조회
select * from tbl_dongnews where ds_no = 3;

-- 우리동소식 목록 최종
select * from (select A.* ,Rownum Rnum from (select * from tbl_dongnews 
    where ds_title like '%%' 
    order by ds_no desc)A) where Rnum > (1 - 1) * 10 and Rnum <= 1 * 10;
    
rollback;

--------------------------------------------------------------------------------

-- 구청소식 테이블 삭제
drop table tbl_gunews;

-- 구청소식 시퀀스 삭제
drop sequence seq_gs;

-- 구청소식 시퀀스 생성
create sequence seq_gs increment by 1 start with 1;

-- 구청소식 테이블 생성
create table tbl_gunews(
    gs_no           number(10)      primary key,
    gs_title        varchar2(300)   not null,
    gs_content      varchar2(4000)  not null,
    gs_depart       varchar2(100),
    gs_tel          varchar2(13),
    gs_hit          number(10)      default 0,
    gs_files        varchar2(1000),
    gs_nuri         varchar2(1)     not null        check(gs_nuri in('Y', 'N')),
    gs_regdate      Date            default sysdate
);
+
-- 구청소식 더미데이터 1
insert into tbl_gunews values(seq_gs.nextval, '영등포 청년 네이버 카페 레벨업 이벤트',
'영등포구 공식 카페영등포 청년 네이버 카페에서 2026년 가입 신규회원 대상으로 이벤트를 엽니다.

신규 가입  후 등업하면 경품이 팡팡팡~ 등급이 올라갈수록 쑥쑥 커지는 경품!

이벤트 내용: 영등포 청년 네이버 카페 신규 가입 후 카페 활동으로 등급 UP → 추첨을 통해 경품 지급
참여대상: 2026년 영등포 청년 네이버 카페 신규 가입 회원(2026. 1. 1. 기준)
이벤트 기간: 2026. 1. 6.(화) ~ 2. 18.(수)

어떻게 참여하면 되나요?
1) 영등포 청년 네이버 카페 신규 가입
2) 이벤트 기간 내 카페 활동으로 조건 달성시 자동 등업
3) 등업 완료 후 영등포 청년 네이버 카페 이벤트 게시물 내 네이버폼 제출
4) 등급별 추첨을 통해 경품 지급(이벤트 종료 후 2주 이내 기프티콘 발송 예정)

등급별 조건 및 경품
1) 4단계 든든청년(1명): 애슐리 샐러드바 평일런치 2인 이용권
2) 3단계 반짝청년(5명): 교촌 간장치킨 한마리 세트
3) 2단계 활짝청년(25명): 스타벅스 아이스 아메리카노
4) 1단계 튼튼청년(50명): 편의점 바나나우유',
'청년정책과',
'02-2670-1662', 300, 'dummy_img_01.jpg', 'Y', sysdate);

-- 구청소식 더미데이터 2
insert into tbl_gunews values(seq_gs.nextval, '영등포구 마을버스 저상버스 예외승인 노선 현황(2025.12.31. 기준)',
'교통약자의 이동편의 증진법 시행규칙 제4조의 3(저상버스 예외승인에 대한 사후 관리 등)제4항에 따라 저상버스 예외승인 노선 및 사유, 해당 사유에 대한 개선계획을 아래와 같이 공개합니다.

○ 저상버스 예외승인 노선 현황',
'교통행정과',
'02-2670-7573', 150, 'dummy_img_01.jpg', 'N', sysdate);

-- 구청소식 더미데이터 3
insert into tbl_gunews values(seq_gs.nextval,
'폐비닐 분리배출 인증 에코마일리지 지급 안내',
'서울시민의 폐비닐 분리배출 생활실천을 도모하고자 폐비닐 분리배출 인증 참여자를 대상으로 에코마일리지를 지급합니다. 폐비닐 재활용 확대를 위해 많은 참여 바랍니다. 

□ 폐비닐 분리배출 인증 개요
  가. 추진기간 : 2026. 1. 5. ~ 6. 30.
  나. 참여혜택 : 등록일 기준 익월 10일 1,000 마일리지 지급(계정당 1회)
  다. 참여자격 : 서울시민(만 14세 이상 에코마일리지 가입 회원)
  라. 참여방법 : 네이버폼 접속, 폐비닐 분리배출 사진 또는 영상 등록 
     ☞ 네이버폼 주소 : https://naver.me/FZ87wFAU
  마. 문의처 : ☎120',
'청소과',
'02-2670-3495', 240, 'dummy_img_01.jpg', 'Y', sysdate);

-- 구청소식 목록
select * from tbl_gunews order by gs_no desc;

commit;

-- 구청소식 더미데이터 탬플릿
insert into tbl_gunews values(seq_gs.nextval,
'제목',
'내용',
'부서',
'02-0000-0000', 100, 'dummy_img_01.jpg', 'Y', sysdate);

-- 구청소식 수정 (테스트)
update tbl_gunews set gs_files = 'dummy_xlsx.xlsx' where gs_no = 2;

-- 구청소식 조회수 증가
update tbl_gunews set gs_hit = gs_hit + 1 where gs_no = 2;

-- 구청소식 조회
select * from tbl_gunews where gs_no = 2;

-- 구청소식 목록 최종
select * from (select A.* ,Rownum Rnum from (select * from tbl_gunews 
    where gs_title like '%%' 
    order by gs_no desc)A) where Rnum > (1 - 1) * 10 and Rnum <= 1 * 10;

rollback;

--------------------------------------------------------------------------------

-- 포토갤러리 테이블 삭제
drop table tbl_gallery;

-- 포토갤러리 시퀀스 삭제
drop sequence seq_gy;

-- 포토갤러리 시퀀스 생성
create sequence seq_gy increment by 1 start with 1;

-- 포토갤러리 테이블 생성
create table tbl_gallery(
    gy_no           number(10)      primary key,
    gy_title        varchar2(300)   not null,
    gy_content      varchar2(4000)  not null,
    gy_depart       varchar2(100),
    gy_tel          varchar2(13),
    gy_hit          number(10)      default 0,
    gy_files        varchar2(1000),
    gy_regdate      Date            default sysdate
);

-- 포토갤러리 등록
insert into tbl_gallery values(seq_gy.nextval, '(10/16) 주민자치위원회 10월 정기회의 개최',
'주민자치위원회 정기회의 개최',
'영등포본동',
'02-2670-1026', 80, 'dummy_img_01.jpg', sysdate);

-- 포토갤러리 더미데이터 2
insert into tbl_gallery values(seq_gy.nextval, '(10/25) 영등포본동 한마음 동민한마음체육대회 개최',
'(10/25) 영등포본동 한마음 동민한마음체육대회 개최',
'영등포본동',
'02-2670-1025', 67, 'dummy_img_02.jpg', sysdate);

-- 포토갤러리 더미데이터 3
insert into tbl_gallery values(seq_gy.nextval, '(10/29) 자원봉사회 김장 나눔 행사',
'(10/29) 자원봉사회 김장 나눔 행사',
'영등포본동',
'02-3457-7032', 55, 'dummy_img_01.png,dummy_img_02.png', sysdate);

-- 포토갤러리 목록
select * from tbl_gallery order by gy_no desc;

commit;

-- 포토갤러리 더미데이터 탬플릿
insert into tbl_gallery values(seq_gy.nextval, '제목',
'내용',
'부서',
'02-0000-0000', 30, 'dummy_img_01.jpg', sysdate);

-- 포토갤러리 수정 (테스트용)
update tbl_gallery set gy_files = 'dummy_img_01.png' where gy_no = 2;

-- 포토갤러리 조회수 증가
update tbl_gallery set gy_hit = gy_hit + 1 where gy_no = 2;

-- 포토갤러리 조회
select * from tbl_gallery where gy_no = 2;

-- 포토갤러리 목록 최종
select * from (select A.* ,Rownum Rnum from (select * from tbl_gallery 
    where gy_title like '%%' 
    order by gy_no desc)A) where Rnum > (1 - 1) * 10 and Rnum <= 1 * 10;

rollback;


--------------------------------------------------------------------------------

-- 자치회관 게시판 테이블 삭제
drop table tbl_community;

-- 자치회관 게시판 시퀀스 삭제
drop sequence seq_cy;

-- 자치회관 게시판 시퀀스 생성
create sequence seq_cy increment by 1 start with 1;

-- 자치회관 게시판 테이블 생성
create table tbl_community(
    cy_no           number(10)      primary key,
    cy_title        varchar2(300)   not null,
    cy_content      varchar2(4000)  not null,
    cy_depart       varchar2(100),
    cy_dong         varchar2(100),
    cy_hit          number(10)      default 0,
    cy_files        varchar2(1000),
    cy_regdate      Date            default sysdate
);

-- 자치회관 게시판 더미데이터 1
insert into tbl_community values(seq_cy.nextval, '영등포본동 자치회관 운영세칙',
'영등포본동 자치회관 운영세칙',
'영등포본동', '영등포본동', 1000, 'dummy_hwp.hwp', sysdate);

-- 자치회관 게시판 더미데이터 2
insert into tbl_community values(seq_cy.nextval, '영등포본동 자치회관 운영세칙 일부개정',
'영등포본동 자치회관 운영세칙',
null, '영등포본동', 900, 'dummy_img_02.jpg,dummy_hwp.hwp', sysdate);

-- 자치회관 게시판 더미데이터 3
insert into tbl_community values(seq_cy.nextval, '주민자치회 1월 정기회의 및 회의록',
'운영세칙과 임원선출',
'영등포본동', '영등포본동' ,760, 'dummy_pptx.pptx,dummy_xlsx.xlsx', sysdate);

-- 자치회관 게시판 목록
select * from tbl_community order by cy_no desc;

commit;

-- 자치회관 게시판 조회수 증가
update tbl_community set cy_hit = cy_hit + 1 where cy_no = 2;

-- 자치회관 게시판 조회
select * from tbl_community where cy_no = 2;

-- 자치회관 게시판 목록 최종
select * from (select A.* ,Rownum Rnum from (select * from tbl_community 
    where cy_title like '%%' 
    order by cy_no desc)A) where Rnum > (1 - 1) * 10 and Rnum <= 1 * 10;

rollback;
