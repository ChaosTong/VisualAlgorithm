//
//  ViewController.swift
//  VisualAlgorithm
//
//  Created by ChaosTong on 16/11/8.
//  Copyright © 2016年 ChaosTong. All rights reserved.
//
import UIKit
import Foundation

class ViewController: UIViewController {

    // MARK: - 排序数组
    lazy var unsortedArray = [Int]()
    let kScreenW = UIScreen.main.bounds.size.width
    let kScreenH = UIScreen.main.bounds.size.height - 44
    // MARK: - 排序的数组长度
    let count = 100
    // MARK: - 线程同步信号量
    let semaphore = DispatchSemaphore(value: 1)
    
    var segmentControl = UISegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
        
    func initUI() {
        initData()
        segmentControl = UISegmentedControl.init(items: ["归并","插入","冒泡","选择"])
        segmentControl.frame = CGRect(x: 0, y: 64 , width: kScreenW, height: 29)
        segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self, action: #selector(onSegmentControlChanged), for: UIControlEvents.valueChanged)
        self.view.addSubview(segmentControl)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "重置", style: .plain, target: self, action: #selector(initData))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "排序", style: .plain, target: self, action: #selector(onSort))
    }
    
    func onSegmentControlChanged(segmentControl: UISegmentedControl) {
        initData()
    }
    // MARK: - 释放内存
    func releaseMemory() {
        while self.view.subviews.count > 5 {
            self.view.subviews[5].removeFromSuperview()
        }
    }
    
    func onSort() {
        releaseMemory()
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
    }
    
    func initData() {
        var i = 1
        unsortedArray.removeAll()
        while i < count {
            unsortedArray.append(Int(arc4random()%1000)+1)
            i += 1
        }
        setupUI(unsortedArray)
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
    // MARK: - 动画绘制
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
    
    //MARK: - 选择排序
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
                    self.reloadView(nowTime: nowTime, array: a)
                }
            }
        }
    }
    
    //MARK：－ 归并排序 冒泡实现
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
    
    //MARK: - 插入排序
    func insertionSort(_ nowTime: TimeInterval, _ isOrderedBefore: @escaping (Int, Int) -> Bool) {
        DispatchQueue.global(qos: .userInitiated).async {
            var a = self.unsortedArray
            for x in 1..<a.count{
                var y = x
                while  y > 0 && isOrderedBefore(a[y], a[y - 1])  {
                    swap(&a[y-1],&a[y])
                    self.reloadView(nowTime: nowTime, array: a)
                    y -= 1
                }
            }
        }
    }
    
    // MARK: - 归并排序 从上至下
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
}

