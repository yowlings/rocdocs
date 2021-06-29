# cartographer学习笔记

## 调参

### 参数文件加载机制

cartographer的参数文件采用.lua文件实行逐级包含来实现参数的输入。

以官方文档的背包2d的样例为例，其使用的参数文件为存在cartographer_ros/configuration_files目录下的backpack_2d.lua文件。

然而，其所包含的map_builder.lua以及trajectory_builder.lua文件并不在该同级目录下。

经反复测试，其所包含的这两个文件在编译安装cartographer时安装到了/usr/local/share/cartographer/configuration_files目录下，移除该目录时程序运行出错。

而在移除该目录并将其中的文件复制到cartographer_ros/configuration_files时程序运行正常。

并且，在两个目录都存在这些被包含的文件时，本ros包同级目录的文件优先生效，而系统安装目录文件未起作用。

在实际使用中，/usr/local/share/cartographer/configuration_files中的参数文件为标准模板文件，可以不用拷贝到ros包目录下修改，而是直接在backpack_2d.lua再次指定需要修改的在/usr/local/share/cartographer/configuration_files/map_builder.lua中的值即可。如：

```lua
MAP_BUILDER.use_trajectory_builder_2d = true
TRAJECTORY_BUILDER_2D.num_accumulated_range_data = 10
```

### 后台线程数量控制

参数位于map_builder.lua文件中通过num_background_threads参数指定，直接在backpack_2d.lua中修改即可。

```
MAP_BUILDER.num_background_threads = 2
```

[sdasuhd](grpc)

