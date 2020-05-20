# HFPrettyTimer
 
 基于NSTimer 的扩展，主要包括两个点
 
        1，弱化target ，NSTimer 是对target 的强引用。然后target 再持有 timer。造成循环引用
        2，自动invalidate， 现在github上很多弱化target的timer，但是极少有自动invalidate。
           加这个的考虑是。既然target 都被释放了。timer还运行个什么？
  
  和HFTimer(https://github.com/helfyz/HFTimer) 不同的是， HTTimer 检测的是timer本身不被持有，便会被销毁
  HFPrettyTimer 检测的是target，target被销毁，timer也没有存在的意义了吧
  
  
   不知道为什么，pod一直push不上， 暂时 这么用吧
   
       pod 'HFPrettyTimer', :git => 'https://github.com/helfyz/HFPrettyTimer.git', :tag=> '0.1.0'
 
