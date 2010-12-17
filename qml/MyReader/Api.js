Qt.include("json2.js")

var Api = {};

//prefix url

Api.auth_url = "https://www.google.com/accounts/ClientLogin";

Api.token_url = "http://www.google.com/reader/api/0/token"

Api.api_prefix = "https://www.google.com/reader/api/0/";

Api.atom_prefix = "https://www.google.com/reader/atom/";

/** atom urls **/

Api.reading_list_url = Api.atom_prefix+"user/-/state/com.google/reading-list"

Api.your_follows_url = Api.atom_prefix+"user/-/state/com.google/broadcast-friends"

Api.starred_url = Api.atom_prefix+"user/-/state/com.google/starred"

Api.notes_url = Api.atom_prefix+"user/-/state/com.google/created"

/** api edit **/

Api.subscription_edit_url = api_prefix+"subscription/edit";

Api.tag_edit_url = api_prefix+"tag/edit";

Api.edit_tag_url = api_prefix+"edit-tag";

Api.disable_tag_url = api_prefix+"disable-tag";

/** api list **/

Api.tag_list_url = api_prefix+"tag/list";

Api.subscription_list_url = api_prefix+"subscription/list";

Api.preference_list_url = api_prefix+"preference/list";

Api.unread_count_url = api_prefix+"unread-count";

//google clientLogin
Api.login = function(email,passwd,callback){
    var auth_params = "accountType=HOSTED_OR_GOOGLE&Email="+email+"&Passwd="+passwd+"&service=reader&source=J-MyReader-1.0";
    var http = new XMLHttpRequest()
    http.onreadystatechange = function() {
        if (http.readyState == XMLHttpRequest.DONE) {
            console.log("auth result: "+ http.status+"  "+http.statusText);
            if(http.status==200){
                //console.log("resp:"+http.getAllResponseHeaders());
                var arrs = http.responseText.split('\n')
                for(var idx in arrs){
                    var arr = arrs[idx]
                    //console.log(arr+"\n\n");
                    var tmp = arr.split('=');
                    if(tmp[0]=="Auth"){
                        auth = tmp[1];
                    }else if(tmp[0]=="SID"){
                        sid = tmp[1];
                    }
                    if(auth&&sid)
                        callback({auth:auth,sid:sid});
                }
            }
        }
    }
    http.open("POST", Api.auth_url);
    http.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    http.setRequestHeader("Content-Length", auth_params.length);
    try {
      console.log("http auth send")
      http.send( auth_params );
    } catch (e) {
        console.log(e)
    }
}

//get token
Api.getToken = function(auth,sid,callback){
    var http = new XMLHttpRequest();
    http.onreadystatechange = function() {
        if (http.readyState == XMLHttpRequest.DONE) {
            console.log("updateAtom:"+http.status+"  "+http.statusText);
            //console.log("resp:"+http.getAllResponseHeaders());
            if(http.status==200){
                callback({code:0,data:http.reponseText});
            }else if(http.status==401){
                callback({code:1});
            } else{
                callback({code:-1,error:http.status+"  "+http.statusText});
            }
        }
    }
    http.open("GET", atom_url);
    http.setRequestHeader("Authorization","GoogleLogin auth="+auth);
    http.setRequestHeader("Cookie","SID="+sid);
    try {
        http.send();
        console.log("http getFeeds send "+atom_url)
    } catch (e) {
        console.log(e)
        callback({code:-1,error:e});
    }
}

//update atom feed
Api.updateAtom = function(atom_url,auth,sid,callback){
    var http = new XMLHttpRequest();
    http.onreadystatechange = function() {
        if (http.readyState == XMLHttpRequest.DONE) {
            console.log("updateAtom:"+http.status+"  "+http.statusText);
            //console.log("resp:"+http.getAllResponseHeaders());
            if(http.status==200){
                var jresult = []
                var doc = http.responseXML.documentElement;
                for (var ii = 0; ii < doc.childNodes.length; ++ii) {
                    if(doc.childNodes[ii].nodeName=="entry"){
                        var entry = doc.childNodes[ii]
                        var tag,title,from,feed,content;
                        for (var j = 0; j < entry.childNodes.length; ++j) {
                            var nodename = entry.childNodes[j].nodeName;
                            if(nodename=="id"){
                                tag = entry.childNodes[j].firstChild.nodeValue;
                            }else if(nodename=="title"){
                                title = entry.childNodes[j].firstChild.nodeValue;
                            }else if(nodename=="source"){
                                feed = entry.childNodes[j].attributes[0].value;
                                from = entry.childNodes[j].childNodes[1].firstChild.nodeValue;
                            }else if(nodename=="summary"||nodename=="content"){
                                content =  entry.childNodes[j].firstChild.nodeValue;
                            }
                        }
                        jresult.push({tag:tag,title:title,from:from,feed:feed,content:content});
                    }
                }
                callback({code:0,data:jresult});

            }else if(http.status==401){
                callback({code:1});

            } else{
                callback({code:-1,error:http.status+"  "+http.statusText});
            }
        }
    }
    http.open("GET", atom_url);
    http.setRequestHeader("Authorization","GoogleLogin auth="+auth);
    http.setRequestHeader("Cookie","SID="+sid);
    http.setRequestHeader("accept-encoding", "gzip, deflate")
    try {
        http.send();
        console.log("http getFeeds send "+atom_url)
    } catch (e) {
        console.log(e)
        callback({code:-1,error:e});
    }
}

Api.updateReadingList = function(auth,sid,callback){
    Api.updateAtom(Api.reading_list_url,auth,sid,callback);
}

Api.updateYFollows = function(auth,sid,callback){
    Api.updateAtom(Api.your_follows_url,auth,sid,callback);
}
Api.updateStreed = function(auth,sid,callback){
    Api.updateAtom(Api.starred_url,auth,sid,callback);
}
Api.updateNotes = function(auth,sid,callback){
    Api.updateAtom(Api.notes_url,auth,sid,callback);
}

Api.updateSubscriptionList = function(auth,sid,callback){
    var http = new XMLHttpRequest();
    http.onreadystatechange = function() {
        if (http.readyState == XMLHttpRequest.DONE) {
            console.log("updateSubscriptionList:"+http.status+"  "+http.statusText);
            //console.log("resp:"+http.getAllResponseHeaders());
            if(http.status==200){
                callback({code:0,data:JSON.parse(http.responseText).subscriptions});
            }else if(http.status==401){
                callback({code:1});
            } else{
                callback({code:-1,error:http.status+"  "+http.statusText});
            }
        }
    }
    http.open("GET", atom_url);
    http.setRequestHeader("Authorization","GoogleLogin auth="+auth);
    http.setRequestHeader("Cookie","SID="+sid);
    http.setRequestHeader("accept-encoding", "gzip, deflate")
    try {
        http.send();
        console.log("http getFeeds send "+atom_url)
    } catch (e) {
        console.log(e)
        callback({code:-1,error:e});
    }
}









