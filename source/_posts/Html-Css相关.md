---
title: Html/Css相关
date: 2019-03-19 12:17:18
tags: Html/Css
---

### box-shadow

`box-shadow:1px 2px 3px 4px #ccc inset；`

以上六个值的含义：1px  从原点开始，沿x轴正方向的长度（倘若为负值，为沿x轴负方向的长度）；

　　　　　　　　　2px  从原点开始，沿y轴正方向的长度；（倘若为负值，为沿y轴负方向的长度）；

　　　　　　　　　3px  阴影的模糊度，只允许为正值；

　　　　　　　　　4px  阴影扩展半径；

　　　　　　　　　#ccc  阴影颜色；

　　　　　　　　　 inset  设置为内阴影（如果不写这个值，默认为外阴影）；

```css
box-shadow:    0px -10px 0px 0px #ff0000,   /*上边阴影  红色*/

                -10px 0px 0px 0px #3bee17,   /*左边阴影  绿色*/

                10px 0px 0px 0px #2279ee,    /*右边阴影  蓝色*/

                0px 10px 0px 0px #eede15;    /*下边阴影  黄色*/

box-shadow:    0px -10px 0px 0px #ff0000,   /*上边阴影  红色*/

                -10px 0px 0px 0px #3bee17,   /*左边阴影  绿色*/

                10px 0px 0px 0px #2279ee,    /*右边阴影  蓝色*/

                0px 10px 0px 0px #eede15;    /*下边阴影  黄色*/
```

### IE9以上 input 文本框的X和密码的眼睛图标

```css
/* 
    IE9和9以上 input 新增文本框的清空和密码输入框的眼睛显示功能 
    下面代码不支持IE9
*/
.login-form ::-ms-clear, .login-form ::-ms-reveal {
    display: none;
}
```

### input placeholder

**Firefox placeholder有一个默认的设置opacity：0.4；所以会出现一个问题，设置为#000的时候，页面上面还是没有改变**

```css
input::-webkit-input-placeholder,/*chorme, safari*/
input:-moz-placeholder,  /*Firefox V18及以下*/
input::-moz-placeholder, /*Firefox 19*/
input:-ms-input-placeholder  { /*IE 10*/
    color: #000;
}

input:-moz-placeholder,
input::-moz-placeholder {
    opacity: 1;
}

/* scss mixin写法 */
@mixin placeholder {
  ::-webkit-input-placeholder {@content}
  :-moz-placeholder           {@content}
  ::-moz-placeholder          {@content}
  :-ms-input-placeholder      {@content}  
}
 
input {
  @include placeholder {
    color: #000;
  }
}
```

### 适应手机

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <!-- meta 参数说明
    width = device-width：宽度等于当前设备的宽度
    height = device-height：高度等于当前设备的高度
    initial-scale：初始的缩放比例（默认设置为1.0）
    minimum-scale：允许用户缩放到的最小比例（默认设置为1.0）
    maximum-scale：允许用户缩放到的最大比例（默认设置为1.0
    user-scalable：用户是否可以手动缩放（默认设置为no，因为我们不希望用户放大缩小页面） -->
```

### checkbox 默认样式修改

```css
<input id="color-input-red" class="chat-button-location-radio-input" type="checkbox" name="color-input-red" value="#f0544d" />
<label  for="color-input-red"></label >

/*lable标签的大小、位置、背景颜色更改，在css选择时，“+”代表相邻元素，即当前元素的下一元素*/
#color-input-red+label {
    display: block;
    width: 20px;
    height: 20px;
    cursor: pointer;
    position: absolute;
    top: 2px;
    left: 15px;
    background: rgba(240, 84, 77, 1);
}

/*当input框为选中状态时，lable标签的样式，其中在css选择时，“：”表示当前input框的值，即checked；
      该部分主要对显示的“对号”的大限居中方式，显示颜色进行了设置*/
#color-input-red:checked+label::before {
    display: block;
    content: "\2714";
    text-align: center;
    font-size: 16px;
    color: white;
}
```