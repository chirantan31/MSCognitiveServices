const request = require('request');
var Cookie = require('request-cookies').Cookie;
var wget = require('node-wget');
var url_directLogin = 'https://echo360.org/directLogin';
var url_login = 'https://echo360.org/login';
var url_home = 'https://echo360.org/home';
var url_syllabus = 'https://echo360.org/section';
var email = 'hongyuw2@illinois.edu';
var password = 'JmjlfZYERRIvbYjb';

//j.setCookie(cookie, url);
request({ url: url_directLogin }, (error_directLogin, response_directLogin, body_directLogin) => {
    if (error_directLogin) { return console.log(error_directLogin); }
    var cookie_directLogin = response_directLogin.headers['set-cookie'][0];
    var play_session_directLogin = new Cookie(cookie_directLogin);
    var csrf_token = play_session_directLogin.value.substring(play_session_directLogin.value.indexOf('csrf') + 10)

    var options_login = {
        method: 'POST',
        url: url_login,
        qs: { csrfToken: csrf_token },
        headers:
        {
            'Content-Type': 'application/x-www-form-urlencoded',
            Cookie: play_session_directLogin.key + "=" + play_session_directLogin.value
        },
        form:
        {
            email: email,
            password: password,
            action: 'Save'
        }
    };

    request(options_login, function (error_login, response_login, body_login) {
        if (error_login) throw new Error(error_login);

        var cookie_login = response_login.headers['set-cookie'][0];
        var play_session_login = new Cookie(cookie_login);
        var options_home = {
            method: 'GET',
            url: url_home,
            headers:
            {
                'Content-Type': 'application/x-www-form-urlencoded',
                Cookie: play_session_login.key + "=" + play_session_login.value
            }
        };

        request(options_home, function (error_home, response_home, body_home) {
            if (error_home) throw new Error(error_home);
            var cookie_home = response_home.headers['set-cookie'];
            var cloudFront_Key_Pair_Id = new Cookie(cookie_home[0]);
            var cloudFront_Policy = new Cookie(cookie_home[1]);
            var cloudFront_Signature = new Cookie(cookie_home[2]);
            console.log(cloudFront_Key_Pair_Id.key + "=" + cloudFront_Key_Pair_Id.value);
            console.log(cloudFront_Policy.key + "=" + cloudFront_Policy.value);
            console.log(cloudFront_Signature.key + "=" + cloudFront_Signature.value);
            var download_header = cloudFront_Key_Pair_Id.key + "=" + cloudFront_Key_Pair_Id.value;
            download_header += "; " + cloudFront_Policy.key + "=" + cloudFront_Policy.value;
            download_header += "; " + cloudFront_Signature.key + "=" + cloudFront_Signature.value;
            console.log(download_header);
            var body_home_str = JSON.stringify(body_home);
            var sections_str = body_home_str.match(/\/section\/([\w-]*)\/home\\" target([^>]*)>/g);
            // console.log(sections_str);
            var courses = [];
            for (i = 0; i < 2; i++) {
                var course_id = sections_str[i].substring(sections_str[i].indexOf('in ') + 3);
                course_id = course_id.substring(0, course_id.search(/\s[\w]+\s-/g));
                var section_id = sections_str[i].substring(9, sections_str[i].indexOf('/home'));
                courses.push([course_id, section_id]);
            }
            console.log(courses);
            // var course_id = '';
            // var section_id = '';
            courses.forEach(function(course) {
                console.log(course);
                var options_syllabus = {
                    method: 'GET',
                    url: url_syllabus + '/' + course[1] + '/syllabus',
                    headers:
                    {
                        'Content-Type': 'application/x-www-form-urlencoded',
                        Cookie: play_session_login.key + "=" + play_session_login.value
                    }
                };
                request(options_syllabus, function (error_syllabus, response_syllabus, body_syllabus) {
                    if (error_home) throw new Error(error_home);
                    var syllabus = JSON.parse(response_syllabus.body);
                    var audio_data_arr = syllabus['data'];
                    for (j = 0; j < audio_data_arr.length; j++) {
                        var audio_data = audio_data_arr[j];
                        var audio_url = audio_data['lesson']['video']['media']['media']['current']['audioFiles'][0]['s3Url'];
                        console.log(audio_url);
                        wget({
                            url: audio_url,
                            dest: course[0] + '_' + String(j) + '.mp3',
                            headers:
                            {
                                Cookie: download_header
                            },
                            }, function (error_download, response_download, body_download) {
                                if(error_download) throw new Error(error_download);
                        });
                    }
                });
            });
        });
    });
});
