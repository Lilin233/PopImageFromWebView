
function autolayoutImg(){
    var objs = document.getElementsByTagName('img');
    for(var i=0;i<objs.length;i++){
        objs[i].style.height = 'auto';
        objs[i].style.width = '100%'
    };
        return objs.length;
};

function addClickFun(){
    var objs = document.getElementsByTagName('img');
    for(var i=0;i<objs.length;i++){
        objs[i].index = i;
        objs[i].onclick=function(){
        document.location="myweb:imageClick:" + this.getBoundingClientRect().left + '*' + this.getBoundingClientRect().top + '*' + this.width +'*' + this.height + '*' + this.src + '*' + this.index;
        };
    };
    return objs.length;
};