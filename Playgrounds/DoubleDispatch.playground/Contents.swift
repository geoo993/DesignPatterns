
// MARK: - Animal
class Animal { // <-- "Visitable"
  func speak() {
    print("~Animal sounds")
  }
  
  func exhibit(at zoo: Zoo) { // <-- accept(_ visitor:)
    zoo.exhibit(self)
  }
}

// MARK: - Dog
class Dog: Animal {
  override func speak() {
    print("~Ruff ruff~")
  }
  
  override func exhibit(at zoo: Zoo) {
    zoo.exhibit(self)
  }
}

// MARK: - Monkey
class Monkey: Animal {
  override func speak() {
    print("~Oooh ooh ah ah~")
  }
  
  override func exhibit(at zoo: Zoo) {
    zoo.exhibit(self)
  }
}

// MARK: - Zoo
class Zoo { // Visitor
  func exhibit(_ animal: Animal) {  // visit(_ visitable:)
    animal.speak()
    print("What type of animal are you?")
    print("")
  }
  
  func exhibit(_ dog: Dog) {
    dog.speak()
    print("Hey there, doggie!")
    print("")
  }
  
  func exhibit(_ monkey: Monkey) {
    monkey.speak()
    print("Hey lil' monkey")
    print("")
  }
}


// MARK: - Testing
let zoo = Zoo()
let dog = Dog()
let monkey = Monkey()
let dogAnimal: Animal = Dog()

// MARK: - Single Dispatch
print("--- Single Dispatch ---")

dog.speak()
dogAnimal.speak()

// we have automatically lost the type information for Dog.
// This is because swift does not automatically perform double dispatch
// it only performs single dispatch.
zoo.exhibit(dog)

// because dogAnimal is a Dog we can get the type information from Dog.
zoo.exhibit(dogAnimal)


// We can peform double dispatch ourself
// MARK: - Double Dispatch
print("--- Double Dispatch ---")

dog.exhibit(at: zoo)
dogAnimal.exhibit(at: zoo)


