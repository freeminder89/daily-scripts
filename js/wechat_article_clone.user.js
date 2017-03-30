// ==UserScript==
// @name         wechat article clone
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  微信文章克隆工具
// @author       Amow
// @match        https://mp.weixin.qq.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    var watcher;
    if(/t=media\/appmsg_list/.test(location.search)){
        var addUrl = $('.btn_new.btn_add:contains(新建)').attr('href');
        localStorage.setItem("cloneUrl", addUrl+"&hly=clone");
        console.log('record url of ', localStorage.getItem("cloneUrl"));
        var modifyBtn = "<button class='btn_primary btn btn_mini clone-article' style='float:right;font-size:12px'>复制</button>";
        $('.appmsg_list').on('mouseenter', '.appmsg', function(e){
            console.log('enter');
            $(e.currentTarget).find('.appmsg_info').append(modifyBtn);
        }).on('mouseleave', '.appmsg', function(e){
            $(e.currentTarget).find('.appmsg_info .btn').remove();
        }).on('click', '.clone-article', function(e){
            var editUrl = $(e.target).closest('.appmsg_col').find('.appmsg_opr a:contains(编辑)').attr('href');
            window.open(editUrl + '&hly=cache');
        });
    }
    if(/hly=cache/.test(location.search)){
        watcher = setInterval(function(){
            if(UE &&　UE.instants.ueditorInstant0.body){
                clearInterval(watcher);
                var cache = UE.instants.ueditorInstant0.body.innerHTML;
                localStorage.setItem("cloneCache", cache);
                window.onbeforeunload =null;
                location.href = localStorage.getItem("cloneUrl");
            }
        }, 100);
    }
    if(/hly=clone/.test(location.search)){
        watcher = setInterval(function(){
            if(UE &&　UE.instants.ueditorInstant0.body){
                clearInterval(watcher);
                var cache = localStorage.getItem("cloneCache");
                UE.instants.ueditorInstant0.setContent(cache);
            }
        }, 100);
    }
})();