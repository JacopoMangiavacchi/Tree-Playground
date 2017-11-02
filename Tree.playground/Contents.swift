import Foundation

protocol BaseTreeProtocol {
    associatedtype ValueType

    var value: ValueType { get }    // No Let in protocol
    
    init(_ value: ValueType)
    func DFS(completition: (ValueType) -> Void)
    func BFS(completition: (ValueType) -> Void)
}

protocol TreeProtocol : BaseTreeProtocol {
    var childs: [Self] { get set }

    func add(_ childValue: ValueType) -> Self
}

enum BinaryTreeBFSOrder {
    case inOrder
    case postOrder
    case preOrder
}

protocol BinaryTreeProtocol : BaseTreeProtocol {
    var left: Self? { get set }
    var right: Self? { get set }

    func DFS(order: BinaryTreeBFSOrder, completition: (ValueType) -> Void)
}

extension BinaryTreeProtocol {
    func DFS(order: BinaryTreeBFSOrder, completition: (ValueType) -> Void) {
        switch order {
        case .inOrder:
            left?.DFS(completition: completition)
            completition(value)
            right?.DFS(completition: completition)
        case .postOrder:
            right?.DFS(completition: completition)
            completition(value)
            left?.DFS(completition: completition)
        case .preOrder:
            completition(value)
            left?.DFS(completition: completition)
            right?.DFS(completition: completition)
        }
    }
    
    func DFS(completition: (ValueType) -> Void) {
        DFS(order: .inOrder, completition: completition) //default
    }
    
    func BFS(completition: (ValueType) -> Void) {
        var q = [Self]()
        q.append(self)
        
        while q.count > 0 {
            let d = q.removeFirst()
            
            if let l = d.left {
                q.append(l)
            }
            if let r = d.right {
                q.append(r)
            }
            
            completition(d.value)
        }
    }
}

protocol BinarySearchTreeProtocol : BinaryTreeProtocol {
    func add(_ childValue: ValueType) -> Self
}



final class Tree<T> : TreeProtocol {
    typealias ValueType = T
    
    let value: T
    var childs: [Tree]
    
    init(_ value: T) {
        self.value = value
        childs = [Tree]()
    }
    
    func add(_ childValue: T) -> Tree {
        let child = Tree(childValue)
        childs.append(child)
        return child
    }
    
    func DFS(completition: (T) -> Void) {
        for c in childs {
            c.DFS(completition: completition)
        }
        completition(value)
    }

    func BFS(completition: (T) -> Void) {
        var q = [Tree]()
        q.append(self)
        
        while q.count > 0 {
            let d = q.removeFirst()
            
            for c in d.childs {
                q.append(c)
            }
            
            completition(d.value)
        }
    }
}


final class BinaryTree<T> : BinaryTreeProtocol {
    typealias ValueType = T
    
    let value: T
    var left: BinaryTree?
    var right: BinaryTree?

    init(_ value: T) {
        self.value = value
    }
}


final class BinarySearchTree<T: Comparable> : BinarySearchTreeProtocol {
    typealias ValueType = T
    
    var value: T
    var left: BinarySearchTree?
    var right: BinarySearchTree?
    
    init(_ value: T) {
        self.value = value
    }
    
    func add(_ childValue: ValueType) -> BinarySearchTree {
        if childValue <= value {
            if let l = left {
                return l.add(childValue)
            }
            else {
                left = BinarySearchTree(childValue)
                return left!
            }
        }
        else {
            if let r = right {
                return r.add(childValue)
            }
            else {
                right = BinarySearchTree(childValue)
                return right!
            }
        }
    }
}




//TEST Tree
var d = 10
var t = Tree(0)
for i in 1...3 {
    let c = t.add(i)
    for i in d...d+1 {
        c.add(i)
    }
    d += 2
}

print("Tree DFS:")
t.DFS { print($0) }
print("\nTree BFS:")
t.BFS { print($0) }

print("")

//TEST BinaryTree
var bt = BinaryTree(0)
bt.left = BinaryTree(1)
bt.right = BinaryTree(2)
bt.left?.left = BinaryTree(3)
bt.left?.right = BinaryTree(4)
bt.right?.left = BinaryTree(5)
bt.right?.right = BinaryTree(6)


print("BinaryTree DFS:")
bt.DFS { print($0) }
print("\nBinaryTree BFS:")
bt.BFS { print($0) }

print("")

//TEST BinarySearchTree
//Create BST
//               ( 5 )
//              /     \
//            (3)     (8)
//           /  \     /  \
//         (1)  (4) (7)  (12)
//                       /
//                     (10)
//                     /  \
//                  (9)  (11)
var bst = BinarySearchTree(5)
bst.add(3)
bst.add(8)
bst.add(1)
bst.add(4)
bst.add(7)
bst.add(12)
bst.add(10)
bst.add(9)
bst.add(11)


print("BinarySearchTree DFS inOrder:")
bst.DFS { print($0) }
print("\nBinarySearchTree BFS:")
bst.BFS { print($0) }





