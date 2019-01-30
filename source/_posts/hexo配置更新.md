title: 站点配置更新
tags:
  - Hexo
  - NexT
categories:
  - 前端
author: Cloudy
date: 2019-01-30 10:23:00
---

### 前言

本文转自 https://www.donlex.cn/archives/undefined.html

最近更新了一下站点的一些配置，让网站的趣味性有了一定的提升。主要做了一下几点更新。

1. 添加雪花效果
2. 添加天气插件
3. 加入CNZZ统计 下面将详细分享一下过程经历！

<!--more-->
### 添加雪花效果

实现方法：在 `\themes\next\source\js\src` 目录下新建一个 `snow.js` 文件，复制粘贴一下代码。

其中样式一是六边形的雪片，样式二是小圆点的雪花，其自行调试，选择喜欢的样式。

#### 样式一

```
/*样式一*/
(function($){
	$.fn.snow = function(options){
	var $flake = $('<div id="snowbox" />').css({'position': 'absolute','z-index':'9999', 'top': '-50px'}).html('&#10052;'),
	documentHeight 	= $(document).height(),
	documentWidth	= $(document).width(),
	defaults = {
		minSize		: 10,
		maxSize		: 20,
		newOn		: 1000,
		flakeColor	: "#AFDAEF" /* 此处可以定义雪花颜色，若要白色可以改为#FFFFFF */
	},
	options	= $.extend({}, defaults, options);
	var interval= setInterval( function(){
	var startPositionLeft = Math.random() * documentWidth - 100,
	startOpacity = 0.5 + Math.random(),
	sizeFlake = options.minSize + Math.random() * options.maxSize,
	endPositionTop = documentHeight - 200,
	endPositionLeft = startPositionLeft - 500 + Math.random() * 500,
	durationFall = documentHeight * 10 + Math.random() * 5000;
	$flake.clone().appendTo('body').css({
		left: startPositionLeft,
		opacity: startOpacity,
		'font-size': sizeFlake,
		color: options.flakeColor
	}).animate({
		top: endPositionTop,
		left: endPositionLeft,
		opacity: 0.2
	},durationFall,'linear',function(){
		$(this).remove()
	});
	}, options.newOn);
    };
})(jQuery);
$(function(){
    $.fn.snow({ 
	    minSize: 5, /* 定义雪花最小尺寸 */
	    maxSize: 50,/* 定义雪花最大尺寸 */
	    newOn: 300  /* 定义密集程度，数字越小越密集 */
    });
});
```

#### 样式二

```
/*样式二*/
/* 控制下雪 */
function snowFall(snow) {
    /* 可配置属性 */
    snow = snow || {};
    this.maxFlake = snow.maxFlake || 200;   /* 最多片数 */
    this.flakeSize = snow.flakeSize || 10;  /* 雪花形状 */
    this.fallSpeed = snow.fallSpeed || 1;   /* 坠落速度 */
}
/* 兼容写法 */
requestAnimationFrame = window.requestAnimationFrame ||
    window.mozRequestAnimationFrame ||
    window.webkitRequestAnimationFrame ||
    window.msRequestAnimationFrame ||
    window.oRequestAnimationFrame ||
    function(callback) { setTimeout(callback, 1000 / 60); };

cancelAnimationFrame = window.cancelAnimationFrame ||
    window.mozCancelAnimationFrame ||
    window.webkitCancelAnimationFrame ||
    window.msCancelAnimationFrame ||
	window.oCancelAnimationFrame;
/* 开始下雪 */
snowFall.prototype.start = function(){
    /* 创建画布 */
    snowCanvas.apply(this);
    /* 创建雪花形状 */
    createFlakes.apply(this);
    /* 画雪 */
    drawSnow.apply(this)
}
/* 创建画布 */
function snowCanvas() {
    /* 添加Dom结点 */
    var snowcanvas = document.createElement("canvas");
    snowcanvas.id = "snowfall";
    snowcanvas.width = window.innerWidth;
    snowcanvas.height = document.body.clientHeight;
    snowcanvas.setAttribute("style", "position:absolute; top: 0; left: 0; z-index: 1; pointer-events: none;");
    document.getElementsByTagName("body")[0].appendChild(snowcanvas);
    this.canvas = snowcanvas;
    this.ctx = snowcanvas.getContext("2d");
    /* 窗口大小改变的处理 */
    window.onresize = function() {
        snowcanvas.width = window.innerWidth;
        /* snowcanvas.height = window.innerHeight */
    }
}
/* 雪运动对象 */
function flakeMove(canvasWidth, canvasHeight, flakeSize, fallSpeed) {
    this.x = Math.floor(Math.random() * canvasWidth);   /* x坐标 */
    this.y = Math.floor(Math.random() * canvasHeight);  /* y坐标 */
    this.size = Math.random() * flakeSize + 2;          /* 形状 */
    this.maxSize = flakeSize;                           /* 最大形状 */
    this.speed = Math.random() * 1 + fallSpeed;         /* 坠落速度 */
    this.fallSpeed = fallSpeed;                         /* 坠落速度 */
    this.velY = this.speed;                             /* Y方向速度 */
    this.velX = 0;                                      /* X方向速度 */
    this.stepSize = Math.random() / 30;                 /* 步长 */
    this.step = 0                                       /* 步数 */
}
flakeMove.prototype.update = function() {
    var x = this.x,
        y = this.y;
    /* 左右摆动(余弦) */
    this.velX *= 0.98;
    if (this.velY <= this.speed) {
        this.velY = this.speed
    }
    this.velX += Math.cos(this.step += .05) * this.stepSize;

    this.y += this.velY;
    this.x += this.velX;
    /* 飞出边界的处理 */
    if (this.x >= canvas.width || this.x <= 0 || this.y >= canvas.height || this.y <= 0) {
        this.reset(canvas.width, canvas.height)
    }
};
/* 飞出边界-放置最顶端继续坠落 */
flakeMove.prototype.reset = function(width, height) {
    this.x = Math.floor(Math.random() * width);
    this.y = 0;
    this.size = Math.random() * this.maxSize + 2;
    this.speed = Math.random() * 1 + this.fallSpeed;
    this.velY = this.speed;
    this.velX = 0;
};
// 渲染雪花-随机形状（此处可修改雪花颜色！！！）
flakeMove.prototype.render = function(ctx) {
    var snowFlake = ctx.createRadialGradient(this.x, this.y, 0, this.x, this.y, this.size);
    snowFlake.addColorStop(0, "rgba(255, 255, 255, 0.9)");  /* 此处是雪花颜色，默认是白色 */
    snowFlake.addColorStop(.5, "rgba(255, 255, 255, 0.5)"); /* 若要改为其他颜色，请自行查 */
    snowFlake.addColorStop(1, "rgba(255, 255, 255, 0)");    /* 找16进制的RGB 颜色代码。 */
    ctx.save();
    ctx.fillStyle = snowFlake;
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.size, 0, Math.PI * 2);
    ctx.fill();
    ctx.restore();
};
/* 创建雪花-定义形状 */
function createFlakes() {
    var maxFlake = this.maxFlake,
        flakes = this.flakes = [],
        canvas = this.canvas;
    for (var i = 0; i < maxFlake; i++) {
        flakes.push(new flakeMove(canvas.width, canvas.height, this.flakeSize, this.fallSpeed))
    }
}
/* 画雪 */
function drawSnow() {
    var maxFlake = this.maxFlake,
        flakes = this.flakes;
    ctx = this.ctx, canvas = this.canvas, that = this;
    /* 清空雪花 */
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    for (var e = 0; e < maxFlake; e++) {
        flakes[e].update();
        flakes[e].render(ctx);
    }
    /*  一帧一帧的画 */
    this.loop = requestAnimationFrame(function() {
        drawSnow.apply(that);
    });
}
/* 调用及控制方法 */
var snow = new snowFall({maxFlake:60});
snow.start();
```

然后在 `\themes\next\layout\_layout.swig` 文件里`<body></body>`内部引用即可：

```
<!-- 雪花特效 -->
<script type="text/javascript">
  var windowWidth = $(window).width();
  if (windowWidth > 480) {
    document.write('<script type="text/javascript" src="/js/src/snow.js"><\/script>');
  }
</script>
```



请确保在你添加的代码上面已经引入了JQ，否则你还需要导入jq

```
<script type="text/javascript" src="//libs.baidu.com/jquery/1.8.3/jquery.min.js"></script>
```



### 添加天气插件

网上有很多的天气插件，找了很久发现心知天气非常不错。
获取地址：<https://www.seniverse.com/widget/get>

使用心知天气有两点必备条件：

1. 注册心知天气账号
2. 博客绑定了域名

如果你没有域名但是可以通过IP地址进行访问也是可以添加成功的。

下面说一下详细的过程：

#### 配置插件

有账号之后,登录根据自己喜好配置插件。心知天气的自动适配功能非常的不错。
[![配置心知.PNG](https://i.loli.net/2019/01/07/5c32f266e786e.png)](https://i.loli.net/2019/01/07/5c32f266e786e.png)

#### 安装代码

选择好配置之后，就可以获取心知的插件代码。获取到代码之后，在`\themes\next\layout\_partials\head\custom-head.swig`中添加获取的代码。之后就可以部署到Github上了。

吐槽一下，加载数独真的是很慢，特别是在移动端中，如果你希望你的站点访问速度快一点，建议还是不要为了功能，而放弃用户体验。

### 添加CNZZ统计

刚开始弄NexT主题的时候，对一些配置还不是很明白，所以一直都不敢弄。
今天总算有点精神，就把友盟的统计给加上了。之前一直都是用不蒜子的统计，但是不蒜子统计的内容太过简单了，不能够看到其他的一些数据。

友盟+ 传送门：<https://passport.umeng.com/login?appId=cnzz>

#### 配置站点信息

登录之后，选择右上角的添加站点，配置好你的站点信息

[![cnzz添加站点.PNG](https://i.loli.net/2019/01/07/5c32f21391b50.png)](https://i.loli.net/2019/01/07/5c32f21391b50.png)

#### 获取代码

获取友盟提供给你的代码，友盟提供了很多的样式，随便复制一份就行。
[![cnzz代码.PNG](https://i.loli.net/2019/01/07/5c32f22e7156f.png)](https://i.loli.net/2019/01/07/5c32f22e7156f.png)

在`\themes\next\layout\_third-party\analytics\cnzz-analytics.swig`中将原来的代码全部删除，复制下面的代码：
*ps：如果没有该文件，请自行创建然后复制修改下面的代码*

```
{% if theme.cnzz_siteid %}
<div>
<!-- 填写你的友盟代码 -->
<script type="text/javascript">
	var cnzz_protocol = (("https:" == document.location.protocol) ? " https://" : " http://");
	document.write(unescape("%3Cspan id='cnzz_stat_icon_12'%3E%3C/span%3E%3Cscript 
	src='" + cnzz_protocol + "s19.cnzz.com/z_stat.php%3Fid%3D12%2show%3Dpic' 
	type='text/javascript'%3E%3C/script%3E"));
</script>
<!-- 你的友盟代码 end -->
</div>
{% endif %}
```

#### 修改配置文件

添加了代码之后，还需要修改next的配置文件才能够生效。注意是**主题配置文件**
打开`\themes\next`目录下的`_config.yml`，按`ctrl + F`搜索`CNZZ`,找到之后将注释的内容打开，并设置成true，注意空格

```
# CNZZ count
cnzz_siteid: true
```

这样就可以成功的使用CNZZ进行统计了。建议使用`hexo s`在本地测试，看是否有问题再部署上去。

#### 附赠

在我的博客中，部署友盟上去之后，发现移动端的footer顶上去了。
[![css.PNG](https://i.loli.net/2019/01/07/5c32f24ab04e9.png)](https://i.loli.net/2019/01/07/5c32f24ab04e9.png)
哭死: ( 写博客的时候，才发现不蒜子的统计居然变少了，原来不蒜子对域名前加www和不加www的网站是区分统计的。。。
算了，反正是佛系博主，随缘吧。。。。

打开`\themes\next\source\css\_custom`目录下的`custom.styl`，添加以下代码：

```
// Custom styles.
//mobile style footer
@media (max-width: 767px)
 .content-wrap {
    width: 100%;
    padding: 20px;
    min-height: auto;
    margin-bottom: 30px;
    border-radius: initial;
 }
```



注意`.content-wrap`前面有一个空格，一定要添加，否则博客的样式就全乱了。