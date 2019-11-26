# JSONToSwift
A lite Xcode extension that generates Swift Model in an elegant way.



### 最新版下载

[JSONToSwift - v1.0.0](https://github.com/RickeyBoy/JSONToSwift/blob/master/JSONToSwift.dmg?raw=true)



### 使用说明

1. 选中需要转换的 JSON 代码
2. 在 Editor 选项下选择 JSONToSwift 插件
3. 得到自动映射后的 Swift 代码

![](https://github.com/RickeyBoy/JSONToSwift/blob/master/0.png?raw=true)

![](https://github.com/RickeyBoy/JSONToSwift/blob/master/1.png?raw=true)



### Done

- [x] 获取选中部分内容，生成对应 ObjectMapper 的模型
- [x] 支持的自动类型识别及映射
- [x] 支持多层 JSON
- [x] 支持自动驼峰命名


### TODO
- [ ] 自动删除 JSON
- [ ] 支持声明变量的默认值
- [ ] 支持多种映射方式
- [ ] 支持右键选择
- [ ] 支持快捷键
- [ ] 完善 Error 报错信息
- [ ] 支持提前配置名称（考虑引入 sourcey）
- [ ] 支持额外配置（如是否驼峰命名、修改默认继承类等）
- [ ] 支持自定义模板
- [ ] 开源库标准重构代码
- [ ] 完善 README，上线 v2.0
- [ ] 介绍文献并推广