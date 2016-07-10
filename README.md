# HFPrettyTimer
 
 基于NSTimer 的扩展，主要包括两个点
 
        1，弱化target ，NSTimer 是对target 的强引用。然后target 再持有 timer。造成循环引用
        2，自动invalidate， 现在github上很多弱化target的timer，但是极少有自动invalidate。
           加这个的考虑是。既然target 都被释放了。timer还运行个什么劲？
  
   提供了两种模式。默认采用分类的方式 ，
   
   分类方式
     
      缺点在于。如果是使用中的项目需要过渡的话，需要挨个去改，好处在于。就算没改到的地方。也不会有影响
      
   hook方式   使用前 请定义宏 HF_TIMER_USE_HOOK_MODE
   
     该方式存在两个尴尬点
       1  直接影响全局，不能控制是否需要使用该模式，当然，优点在于不用去挨个修改
       2  尚不清楚是否会对系统造成影响
       
       
   
   
