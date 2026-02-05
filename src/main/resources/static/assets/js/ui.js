$(document).ready(function() {
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
    const $dev_list = $('.header .dev-news ul');
    const $dev_list_item = $('#modalDevStatus .dev-status ul li');
    $dev_list.empty();
    $dev_list.append($dev_list_item.eq(0).clone());
    $dev_list.append($dev_list_item.eq(1).clone());
    $dev_list.append($dev_list_item.eq(2).clone());
    $dev_list.append($dev_list_item.eq(0).clone());

    // GNB element 변수 설정
    const $gnb = $('#gnb');  // GNB 전체 영역
    const $dim = $('.dim');  // GNB, 레이어팝업창 등이 보여질 때 바닥 가려주는 영역
    const $gnbDep1 = $('#gnb [data-gnb-count]');    // GNB 1depth

    // gnb 마우스엔터 이벤트
    $gnb.on('mouseenter', function() {
        gnbActive();
    });

    // GNB 마우스리브 이벤트
    $gnb.on('mouseleave', function() {
        if($('#gnb a:focus').length === 0) {
            gnbDisable();
        }
    });

    // GNB 1뎁스 메뉴 마우스엔터 이벤트
    $gnbDep1.on('mouseenter', function() {
        gnbBg(this);
        $('#header_menu a:focus').blur();
    });

    // 해더메뉴 a 태그 포커스 이벤트
    $('#header_menu a').on('focus', function() {
        if($(this).closest('#gnb').length === 0) {
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

    // GNB 서브메뉴 활성화 함수
    function gnbActive() {
        $gnb.addClass('active');
        $dim.show();
    }

    // GNB 서브메뉴 비활성화 함수
    function gnbDisable() {
        $gnb.removeClass('active');
        $gnbDep1.removeClass('active');
        $dim.hide();
    }

    // GNB 배경 이미지 교체 함수
    function gnbBg(_this) {
        let idx = $(_this).data('gnb-count');
        $('#gnb [data-outline]').hide();
        $('#gnb [data-outline="' + idx + '"]').show();
        $gnbDep1.removeClass('active');
        $(_this).addClass('active');
    }

    // dim 화면 클릭 시 GNB 비활성화
    $dim.on('click', function() {
        if($gnb.hasClass('active')) {
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

    // 날씨 api 연동
    /*$.getJSON('/weather/status', function(data) {
        const dataArray = data.response.body.items.item;
        const map = new Map();
        dataArray.forEach(item => {
            if(!map.has(item.category) && /T1H|SKY|PTY|LGT/.test(item.category)) {
                map.set(item.category, item);
            }
        });
        const firstByCategory = Array.from(map.values()).map(item => ({category: item.category, value: item.fcstValue}));
        const lgt = firstByCategory.filter(item => item.category === 'LGT')[0].value;
        const pty = firstByCategory.filter(item => item.category === 'PTY')[0].value;
        const sky = firstByCategory.filter(item => item.category === 'SKY')[0].value;
        const t1h = firstByCategory.filter(item => item.category === 'T1H')[0].value;

        let weatherText = '맑음';
        let weatherImg = 'weather_01.png';

        // 낙뢰 있을 시
        if(lgt > 0) {
            weatherText = '낙뢰주의';
            weatherImg = 'weather_08.png';
        }
        else {
            // 비 또는 눈 있을 때
            if(pty%4 > 0) {
                if(pty%4 === 3) {
                    weatherText = '눈';
                    weatherImg = 'weather_07.png';
                }
                else if(pty%4 === 2) {
                    weatherText = '비/눈';
                    weatherImg = 'weather_06.png';
                }
                else if(pty%4 === 1) {
                    weatherText = '비';
                    weatherImg = 'weather_05.png';
                }
            }
            else {
                // 구름 상태
                if(sky === 4) {
                    weatherText = '흐림';
                    weatherImg = 'weather_04.png';
                }
                else if(sky === 3) {
                    weatherText = '구름많음';
                    weatherImg = 'weather_03.png';
                }
            }
        }

        const weatherImgEl = $('#weather_temperature_img');
        weatherImgEl.attr({'src': weatherImgEl.attr('data-path') + weatherImg, 'alt': weatherText});
        $('#weather_temperature_num').text(t1h + '˚C');
        $('#weather_temperature_text').text(weatherText);
        $('#weather_image, #weather_status').addClass('active');
    })
    .fail(function(xhr, status, err) {
        console.log(err);
    });

    // 미세먼지 api 연동
    $.getJSON('/weather/dust', function(data) {
        const dataArray = data.response.body.items;
        const dustInfo = dataArray[dataArray.length - 1];
        const pm10Grade = Number(dustInfo.pm10Grade);
        const pm25Grade = Number(dustInfo.pm25Grade);
        const gradeText = ['좋음', '보통', '나쁨', '매우나쁨'];
        $('#dust_text1').addClass('dust0' + pm10Grade).text(gradeText[pm10Grade - 1]);
        $('#dust_text2').addClass('dust0' + pm25Grade).text(gradeText[pm25Grade - 1]);
        $('#weather_dust').addClass('active');
    })
    .fail(function(xhr, status, err) {
        console.log(err);
    });*/
});

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
    const LAYER_AlERT = $('.layer-alert');

    LAYER_AlERT.remove();
    clearTimeout(layerAlertTimeout);
    let html = '<div class="layer-alert">' + text + '</div>';
    $('body').append(html);
    LAYER_AlERT.stop().fadeIn(fadeInTime);
    layerAlertTimeout = setTimeout(function() {
        LAYER_AlERT.stop().fadeOut(fadeOutTime, function() {
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
                if(e.target.id === id) {
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