# VisualAlgorithm

1. 插入排序
2. 选择排序
3. 归并排序 从上至下
4. 归并排序 从下至上

## 插入排序

目标：将一个数据从高(低)到低(高)排序，下例有低到高。

-   将数组放入一个堆中，这个堆是乱序的

-   将第一个元素作为最小元素放入已排序堆中

-   将第二个元素与之比较，插在前面或后面(😈),这样就有一个由两个元素组成的有序数组了，下一个元素和前两个依次比较，插入到恰当的位置

-   重复上述操作，至遍历完数组

    ![插入排序.gif](http://ww3.sinaimg.cn/large/7a1656d9gw1f9o9m96h46g20ko120b2g.gif)

```swift
func insertionSort(_ nowTime: TimeInterval, _ isOrderedBefore: @escaping (Int, Int) -> Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            var a = self.unsortedArray
            for x in 1..<a.count{
                var y = x
                while  y > 0 && isOrderedBefore(a[y], a[y - 1])  {
                    swap(&a[y-1],&a[y])
                    // MARK: - 动画操作
                    self.reloadView(nowTime: nowTime, array: a)
                    y -= 1
                }
            }
        }
    }
```

## 选择排序

- 首先选择第一个元素为最小(最大)元素，记录下他的位置，遍历剩余数组如果有元素小于(大于)最小(最大)元素，更新最小(最大)元素位置信息，至遍历完毕，比较第一次设置的最小(最大)位置是否和最终的位置一致，否则为后者，并交换两个元素的位置。

- 重复上述操作，这次将第二个元素设置为待交换元素。

  ![选择排序.gif](http://ww2.sinaimg.cn/large/7a1656d9gw1f9o9n6s84kg20ko120dz9.gif)

```swift
func SelectionSort(nowTime: TimeInterval) {
        DispatchQueue.global(qos: .userInitiated).async {
            var a = self.unsortedArray
            
            for x in 0..<a.count - 1 {
                var lowest = x
                for y in x + 1 ..< a.count {
                    if a[y] < a[lowest] {
                        lowest = y
                    }
                }
                if x != lowest {
                    swap(&a[x], &a[lowest])
                    // MARK: - 动画操作
                    self.reloadView(nowTime: nowTime, array: a)
                }
            }
        }
    }
```

## 归并排序 自上而下

归并算法的思想：将大问题分解成小问题在合并。(下例从小到大)

- 将一个数组一分为2，接着两个数组继续一分为二，keep doing，直至每个数组只含有一个元素

- 开始合并它们，两两比较排序，原来1个1个的有序数组成了，2个2个的有序数组，继续合并直至全部排序

- 函数mergeSort使用递归的方式分解合并一个数组

- 合并函数merge的基本逻辑是：

  - 首先我们比较的对象是两个数组，分别加上两个游标，放置在数组的0位置，同步比较游标上的元素，较小一方放入新有序数组中，并且较小一方数组游标+1，相等则游标同时+1。继续比较游标当前元素大小，如果一个数组游标到达最后一个元素了，而另一个数组还有元素，由于每个数组的内部都是已经排序过的，所以只要把剩余的元素加入到一排序数组就可以了

    ![归并排序1.gif](http://ww2.sinaimg.cn/large/7a1656d9gw1f9o9o06zgmg20ko1207wh.gif)

```swift
func mergeSort(_ array: [Int], _ nowTime: TimeInterval) -> [Int] {
        guard array.count > 1 else {
            return array
        }
        let middleIndex = array.count / 2
        let leftArray = mergeSort(Array(array[0..<middleIndex]), nowTime)
        let rightArray = mergeSort(Array(array[middleIndex..<array.count]), nowTime)
        
        return merge(leftPile: leftArray, rightPile: rightArray, nowTime)
    }
    
    func merge(leftPile: [Int], rightPile: [Int], _ nowTime: TimeInterval) -> [Int] {
        var leftIndex = 0
        var rightIndex = 0
        
        var orderedPile = [Int]()
        
        while leftIndex < leftPile.count && rightIndex < rightPile.count {
            if leftPile[leftIndex] < rightPile[rightIndex] {
                orderedPile.append(leftPile[leftIndex])
                self.reloadView(nowTime: nowTime, array: orderedPile)
                leftIndex += 1
            } else if leftPile[leftIndex] > rightPile[rightIndex] {
                orderedPile.append(rightPile[rightIndex])
                self.reloadView(nowTime: nowTime, array: orderedPile)
                rightIndex += 1
            } else {
                orderedPile.append(leftPile[leftIndex])
                leftIndex += 1
                orderedPile.append(rightPile[rightIndex])
                rightIndex += 1
                self.reloadView(nowTime: nowTime, array: orderedPile)
            }
        }
        
        while leftIndex < leftPile.count {
            orderedPile.append(leftPile[leftIndex])
            leftIndex += 1
            self.reloadView(nowTime: nowTime, array: orderedPile)
        }
        
        while rightIndex < rightPile.count {
            orderedPile.append(rightPile[rightIndex])
            rightIndex += 1
            self.reloadView(nowTime: nowTime, array: orderedPile)
        }
        
        return orderedPile
    }
```

## 归并排序 从下至上

由于Int数组，可以直接合并，不需要分解的这个步骤，有点类似冒泡，所以以下是数组直接合并的写法

- 由于不能够直接对要排序数组作修改，所以需要一个临时数组。为了节省空间，使用了一个二维数组z来存放两个数组

- 逻辑和上述的合并逻辑一致：设置两个游标0和1，设置合并宽度width为1，最开始所有数组元素都是独立的，也就完成了分解的步骤，所以我们直接合并。

- 合并成2个2个的数组并且排序，元素0、1，元素2、3 ...

- 将width设置为2，于是4个4个的数组，直至width > n，合并完毕

  ![归并排序2.gif](http://ww4.sinaimg.cn/large/7a1656d9gw1f9o9ocostmg20ko120kjn.gif)

```swift
func mergeSortBottomUp(nowTime: TimeInterval ,_ isOrderedBefore: @escaping (Int, Int) -> Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            let n = self.unsortedArray.count
            
            var z = [self.unsortedArray, self.unsortedArray]
            var d = 0
            
            var width = 1
            while width < n {
                
                var i = 0
                while i < n {
                    
                    var j = i
                    var l = i
                    var r = i + width
                    
                    let lmax = min(l + width, n)
                    let rmax = min(r + width, n)
                    
                    while l < lmax && r < rmax {
                        if isOrderedBefore(z[d][l], z[d][r]) {
                            z[1 - d][j] = z[d][l]
                            l += 1
                            
                            self.reloadView(nowTime: nowTime, array: z[1-d])
                        } else {
                            z[1 - d][j] = z[d][r]
                            r += 1
                            self.reloadView(nowTime: nowTime, array: z[1-d])
                        }
                        j += 1
                    }
                    while l < lmax {
                        z[1 - d][j] = z[d][l]
                        j += 1
                        l += 1
                        self.reloadView(nowTime: nowTime, array: z[1-d])
                    }
                    while r < rmax {
                        z[1 - d][j] = z[d][r]
                        j += 1
                        r += 1
                        self.reloadView(nowTime: nowTime, array: z[1-d])
                    }
                    
                    i += width*2
                }
                
                width *= 2
                d = 1 - d
            }
        }
    }
```

# UI实现方法

排序方法里只会去调用绘图方法，本身的实现完全可以脱离视图

传入参数*nowTime*为当前时间计算出算法动画实现时间(并不是真实的算法速度)，'<' 是比较clourse的操作符

```swift
switch self.segmentControl.selectedSegmentIndex {
        case 0:
            // 归并
            DispatchQueue.global(qos: .userInitiated).async {
                _ = self.mergeSort(self.unsortedArray, NSDate().timeIntervalSince1970)
            }
        case 1:
            // 插入
            insertionSort(NSDate().timeIntervalSince1970, <)
        case 2:
            // 归并 冒泡版
            mergeSortBottomUp(nowTime: NSDate().timeIntervalSince1970, < )
        case 3:
            // 选择
            SelectionSort(nowTime: NSDate().timeIntervalSince1970)
        default:
            break
        }
```

函数initData 构造了一个count -1大小的一个随机数组，范围在1~1000

```swift
func initData() {
        var i = 1
        unsortedArray.removeAll()
        while i < count {
            unsortedArray.append(Int(arc4random()%1000)+1)
            i += 1
        }
        setupUI(unsortedArray)
    }
```

函数setupUI 绘制了数组元素值占1000的比值 乘以 所在UIView的高度，来视觉化一个数组

```swift
func setupUI(_ array: [Int]) {
        releaseMemory()
        var i = 0
        let Arrayview = UIView()
        Arrayview.backgroundColor = UIColor.white
        Arrayview.frame = CGRect(x: 0 , y: 64 + 29 , width: kScreenW, height:kScreenH - 44)
        for x in array {
            let width: CGFloat = (kScreenW / (CGFloat)(count))
            let height: CGFloat = ((kScreenH - 50) * (CGFloat)(x) / 1000)
            let make = CGRect(x: 5 + (CGFloat)(i) * width, y: kScreenH + 44 - 93 , width: width / 2, height:-height)
            let view = UIView.init(frame: make)
            view.backgroundColor = UIColor.blue
            Arrayview.addSubview(view)
            i += 1
        }
        self.view.addSubview(Arrayview)
    }
```

- 如果我的数组有100个元素也就是说我要画100个UIView，会占据几M的内存而已。但是如果我每次数组变化的时候都只往上加而不remove的话，你知道比较的次数有多少吧！对的内存爆炸了，我们需要release掉前面加的UIView，然后再添加我们需要的最后一个看的见的

- 断点查看后，从第6个开始我们都可以去除掉，这样100个元素的排序从内存消耗只增不减到不超过5M

  ```swift
  func releaseMemory() {
          while self.view.subviews.count > 5 {
              self.view.subviews[5].removeFromSuperview()
          }
      }
  ```



## 动画显示

- 在处理完怎么把数组视觉化后，这个变化的动画效果要怎么显现出来呢？在我花了一个下午的调试多线程后，终于解决了。其实原理我是知道的，但是怎么写，怎么实现，花了比较长的时间。

- 原理：UI的刷新需要在主线程，所以排序算法就需要在另一个线程中执行了。下面就是调用绘制动画的方法。其中*semaphore*是值为1的信号量，为了在绘制UI的时候阻塞排序线程，为了让动画有时间可以让肉眼可见，人为的设置了一个短暂的休眠时间，在这个时间之后我们使得信号量+1，排序线程继续执行

- ```Swift
  let semaphore = DispatchSemaphore(value: 1)
  func SortAlgorithm() {
          DispatchQueue.global(qos: .userInitiated).async {
          	当数组元素发生变化，调用动画绘制方法
  			self.reloadView(nowTime: nowTime, array: a)
          }
      }
  func reloadView(nowTime: TimeInterval,array: [Int]) {
          self.semaphore.wait()
          DispatchQueue.main.async {
              self.setupUI(array)
              sleep(UInt32(0.002))
              self.semaphore.signal()
              // 动画的显示速度不与真实算法速度匹配，原因: 动画刷新在元素有交换时，所以同样的归并算法动画速度并不一致
              let interval = (NSDate().timeIntervalSince1970 - nowTime)
              self.title = "耗时(秒): \(interval)"
          }
      }
  ```

  ​

# Links

[Merge Sort](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Merge%20Sort)

[Insert Sort](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Insertion%20Sort)

[Selection Sort](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Selection%20Sort)

[我的微博](http://weibo.com/277113685)

[Github](https://github.com/ChaosTong/)