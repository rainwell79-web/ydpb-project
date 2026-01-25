$(document).ready(function() {
    $.getJSON('/weather/status', function(data) {
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
        weatherImgEl.attr({'src': weatherImgEl.attr('data-path') + weatherImg, 'alt': weatherText}).css('opacity', 1);
        $('#weather_temperature_num').text(t1h + '˚C');
        $('#weather_temperature_text').text(weatherText);
    })
    .fail(function(xhr, status, err) {
        console.log(err);
    });
});