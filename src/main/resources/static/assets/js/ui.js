$(document).ready(function() {

    initUi();

});

/**
 * ui 스크립트 초기화
 * !!!공통영역 load 호출 이후 스크립트 추가를 위해 함수화 한 것이므로 백엔드 개발 시 수정할 수 있음을 인지할 것!!!
 */
function initUi() {

    // 링크 # 처리한 a 태그 클릭 이벤트 시 경고창 출력
    $('a[href="#"]').on('click', function(e) {
        e.preventDefault();
        layerAlert('죄송합니다.<br> 현재 준비중인 메뉴입니다.');
    });

    // 액션 # 처리한 form 태그 submit 이벤트 시 경고창 출력
    $('form[action="#"]').on('submit', function(e) {
        e.preventDefault();
        layerAlert('죄송합니다.<br> 현재 준비중인 메뉴입니다.');
    });

    // dev-news li 요소 추가
    $('.header .dev-news ul').empty();
    $('.header .dev-news ul').append($('#modalDevStatus .dev-status ul li').eq(0).clone());
    $('.header .dev-news ul').append($('#modalDevStatus .dev-status ul li').eq(1).clone());
    $('.header .dev-news ul').append($('#modalDevStatus .dev-status ul li').eq(2).clone());
    $('.header .dev-news ul').append($('#modalDevStatus .dev-status ul li').eq(0).clone());

    // gnb 마우스엔터 이벤트
    $('#gnb').on('mouseenter', function() {
        gnbActive();
    });
    
    // gnb 마우스리브 이벤트
    $('#gnb').on('mouseleave', function() {
        if($('#gnb a:focus').length == 0) {
            gnbDisable();
        }
    });

    // gnb 1뎁스 메뉴 마우스엔터 이벤트
    $('#gnb [data-gnb-count]').on('mouseenter', function() {
        gnbBg(this);
        $('#header_menu a:focus').blur();
    });

    // 해더메뉴 a 태그 포커스 이벤트
    $('#header_menu a').on('focus', function() {
        if($(this).closest('#gnb').length == 0) {
            gnbDisable();
        }
        else {
            gnbActive();
            gnbBg($(this).closest('[data-gnb-count]')[0]);
        }
    });

    $('#gnb a').on('click', function() {
        $(this).blur();
    });

    // gnb 서브메뉴 활성화 함수
    function gnbActive() {
        $('#gnb').addClass('active');
        $('.dim').show();
    }

    // gnb 서브메뉴 비활성화 함수
    function gnbDisable() {
        $('#gnb').removeClass('active');
        $('#gnb [data-gnb-count]').removeClass('active');
        $('.dim').hide();
    }

    // gnb 배경 이미지 교체 함수
    function gnbBg(_this) {
        var idx = $(_this).data('gnb-count');
        $('#gnb [data-outline]').hide();
        $('#gnb [data-outline="' + idx + '"]').show();
        $('#gnb [data-gnb-count]').removeClass('active');
        $(_this).addClass('active');
    }

    // dim 화면 클릭 시 gnb 비활성화
    $('.dim').on('click', function() {
        if($('#gnb').hasClass('active')) {
            gnbDisable();
        }
    });

    // 로케이션 공유 버튼 클릭 이벤트
    $('#btn_share').on('click', function() {
        $(this).toggleClass('btn-close');
        $(this).next().toggleClass('open');
        if($(this).hasClass('btn-close')) {
            $(this).attr('title', 'SNS 메뉴 닫기');
        }
        else {
            $(this).attr('title', 'SNS 공유하기');
        }
    });

    // 모달 여는 버튼 클릭 이벤트
    $('[data-modal="open"]').on('click', function(e) {
        e.preventDefault();
        MODAL.open($(this).attr('data-target'));
    });
}

// 레이어 경고창 timeout 함수 사용을 위한 변수 선언
let layerAlertTimeout;
/**
 * 레이어 경고창 생성 함수
 * @param {String} text : 경고창 텍스트
 */
function layerAlert(text) {
    const fadeInTime = 200;
    const fadeOutTime = 600;
    const delayTime = 1000;

    $('.layer-alert').remove();
    clearTimeout(layerAlertTimeout);
    let html = '<div class="layer-alert">' + text + '</div>';
    $('body').append(html);
    $('.layer-alert').stop().fadeIn(fadeInTime);
    layerAlertTimeout = setTimeout(function() {
        $('.layer-alert').stop().fadeOut(fadeOutTime, function() {
            $(this).remove();
        });
    }, delayTime);
}

// 모달
const MODAL = {
    timeoutFunc: null,
    effectTime: 200,
    /**
     * 모달 열기
     * @param {String} id : 모달(class="modal-wrap") id
     */
    open: function(id) {
        let modalWrap = $('#' + id);
        let modal = modalWrap.find('[data-role="modal"]');

        clearTimeout(this.timeoutFunc);
        $('body').addClass('modal-open');
        modalWrap.show().scrollTop(0);
        modal.attr('tabindex', '0');
        this.timeoutFunc = setTimeout(function() {
            modal.addClass('active');
            modalWrap.find('[data-modal="close"]').bind('click', function() {
                MODAL.close(id);
            });
            modalWrap.bind('click', function(e) {
                if(e.target.id == id) {
                    MODAL.close(id);
                }
            });
        }, 0);
    },
    /**
     * 모달 닫기
     * @param {*} id : 모달(class="modal-wrap") id
     */
    close: function(id) {
        let modalWrap = $('#' + id);
        let modal = modalWrap.find('[data-role="modal"]');

        clearTimeout(this.timeoutFunc);
        modal.removeClass('active');
        modalWrap.unbind('click');
        modalWrap.find('[data-modal="close"]').unbind('click');
        this.timeoutFunc = setTimeout(function() {
            modal.attr('tabindex', '-1');
            modalWrap.hide();
            $('body').removeClass('modal-open');
        }, this.effectTime);
    }
}

const MENU = [{
    id: 'A',
    name: '우리동이야기',
    href: '/',
    sub: [{
        id: 'A',
        name: '영등포본동 주민센터',
        href: '/'
    }, {
        id: 'B',
        name: '직원별업무안내',
        href: '/dong/staff.html'
    }, {
        id: 'C',
        name: '일반현황',
        href: '/dong/status.html'
    }, {
        id: 'D',
        name: '찾아오시는길',
        href: '/dong/directions.html'
    }, {
        id: 'E',
        name: '동유래',
        href: '/dong/origin.html'
    }]
}, {
    id: 'B',
    name: '우리동소식',
    href: '/news/dong_news_list.html',
    sub: [{
        id: 'A',
        name: '우리동소식',
        href: '/news/dong_news_list.html'
    }, {
        id: 'B',
        name: '구청소식',
        href: '/news/gu_news_list.html'
    }, {
        id: 'C',
        name: '포토갤러리',
        href: '/news/gallery_list.html'
    }]
}, {
    id: 'C',
    name: '주민제안',
    href: '/proposal/proposal_guide.html',
    sub: [{
        id: 'A',
        name: '주민제안 안내',
        href: '/proposal/proposal_guide.html'
    }, {
        id: 'B',
        name: '주민제안',
        href: '/proposal/proposal_list.html'
    }]
}, {
    id: 'D',
    name: '자치회관',
    href: '/community/community_guide.html',
    sub: [{
        id: 'A',
        name: '자치회관이란?',
        href: '/community/community_guide.html'
    }, {
        id: 'B',
        name: '자치회관 게시판',
        href: '/community/community_list.html'
    }, {
        id: 'C',
        name: '주민자치의원',
        href: '#'
    }, {
        id: 'D',
        name: '프로그램현황',
        href: '#'
    }]
}];