# c++友元函数

## 特点

- 能访问私有成员
- 破坏封装性
- 友元关系不可传递
- 友元关系的单向性
- 友元声明的形式及数量不受限制

## 简介

私有成员对于类外部的所有程序部分而言都是隐藏的，访问它们需要调用一个公共成员函数，但有时也可能会需要创建该规则的一项例外。

友元函数是一个不属于类成员的函数，但它可以访问该类的私有成员。换句话说，友元函数被视为好像是该类的一个成员。友元函数可以是常规的独立函数，也可以是其他类的成员。实际上，整个类都可以声明为另一个类的友元。

为了使一个函数或类成为另一个类的友元，必须由授予它访问权限的类来声明。类保留了它们的朋友的 "名单"，只有名字出现在列表中的外部函数或类才被授予访问权限。通过将关键字 friend 放置在函数的原型之前，即可将函数声明为友元。

## 格式

友元函数的一般格式如下：
`friend <return type><function name> (<parameter type list>);`

## 示例

在 Budget 类的以下声明中，另一个类的 addBudget 函数 Aux 已声明为友元：
```cpp
class Budget
{
	private:
	static double corpBudget;
	double divBudget;
	public:
	Budget() { divBudget = 0; }
	void addBudget(double b)
	{
		divBudget += b;
		corpBudget += divBudget;
	}
	double getDivBudget() const { return divBudget; }
	static double getCorpBudget() { return corpBudget; }
	static void mainOffice(double);
	friend void Aux::addBudget (double) ; // 友元
};
```
假设另一个 Aux 类代表一个分部的附属办公室，也许在另一个国家。附属办公室提出了一个单独的预算要求，该要求必须添加到整个企业的预算中。则 Aux::addBudget 函数的友元声明告诉编译器，该函数己授予访问 Budget 的私有成员的权限。该函数釆用 double 类型的实参，表示要添加到企业预算中的金额： 
```cpp
class Aux
{
    private:
        double auxBudget;
    public:
        Aux() { auxBudget =0; }
        void addBudget(double);
        double getDivBudget() { return auxBudget; }
};
```
以下是 Aux addBudget 成员函数的定义：
```cpp
void Aux::addBudget(double b)
{
    auxBudget += b;
    Budget::corpBudget += auxBudget;
}
```
形参 b 被添加到企业预算中，这是通过使用表达式 Budget::corpBudget 来访问并实现的。下面的程序演示了这些类在完整程序中的用法。
```cpp
//auxil.h的内容
#ifndef AUXIL_H
#define AUXIL_H
// Aux class declaration.
class Aux
{
    private:
        double auxBudget;
    public:
        Aux() { auxBudget = 0; }
        void addBudget(double);
        double getDivBudget() const { return auxBudget; }
};
#endif
//budget3.h的内容
#ifndef BUDGET3_H
#define BUDGET3_H
#include "auxil.h" // For Aux class declaration
//Budget class declaration.
class Budget {
    private:
        static double corpBudget;
        double divBudget;
    public:
        Budget() { divBudget =0; }
        void addBudget(double b)
        {
            divBudget += b;
            corpBudget += divBudget;
        }
        double getDivBudget() const {return divBudget;}
        static double getCorpBudget() {return corpBudget;}
        static void mainOffice(double);
        friend void Aux::addBudget(double);
};
#endif
//budget3.cpp的内容
#include "budget3.h"
//Definition of static member.
double Budget::corpBudget = 0;
void Budget:imainOffice(double budReq)
{
    corpBudget += budReq;
}
//auxil.cpp的内容
#include "auxil.h"
#include "budget3.h"
void Aux::addBudget(double b)
{
    auxBudget += b;
    Budget::corpBudget += auxBudget;
}
//main程序的内容
//This program demonstrates a static class member variable. #include <iostream>
#include <iomanip>
#include "budget3.h"
using namespace std;
int main()
{
    const int N_DIVISIONS = 4;
    // Get the budget requests for the divisions and offices
    cout << "Enter the main office's budget request:";
    double amount;
    cin >> amount;
    Budget:imainOffice(amount);
    // Create the division and auxiliary offices
    Budget divisions [N_DIVISIONS];
    Aux auxOffices[N_DIVISIONS];
    cout << "\nEnter the budget requests for the divisions and" << "\ntheir auxiliary offices as prompted:\n";
    for (int count = 0; count < N_DIVISIONS; count++)
    {
        double bud;
        cout << "Division " << (count + 1) << ": ";
        cin >> bud;
        divisions[count].addBudget(bud);
        cout << "Division " << (count + 1) << "'s auxiliary office:";
        cin >> bud;
        auxOffices[count].addBudget(bud);
    }
    // Print the budgets
    cout << setprecision (2);
    cout << showpoint << fixed;
    cout << "Here are the division budget requests:\n";
    for (int count = 0; count < N_DIVISIONS; count++)
    {
        cout << "\tDivision: " << (count + 1) << "\t\t\t$ ";
        cout << setw(7);
        cout << divisions[count].getDivBudget() << endl;
        cout << "\tAuxiliary Office of Division " << (count+1);
        cout << "\t$ ";
        cout << auxOffices[count].getDivBudget() << endl;
    }
    // Print total requests
    cout << "\tTotal Requests (including main office): $ ";
    cout << Budget::getCorpBudget() << endl;
    return 0;
}
```
程序输出结果：
Enter the main office's budget request: 100000
Enter the budget requests for the divisions and their auxiliary offices as prompted:
Division 1: 100000
Division 1's auxiliary office: 500000
Division 2: 200000
Division 2's auxiliary office: 40000
Division 3: 300000
Division 3's auxiliary office: 700000
Division 4: 400000
Division 4's auxiliary office: 650000
Here are the division budget requests:
Division: 1    100000.00AuxiliaryOfficeofDivision1 50000.00
Division: 2    200000.00AuxiliaryOfficeofDivision2 40000.00
Division: 3    300000.00AuxiliaryOfficeof.Division3 70000.00
Division: 4    400000.00AuxiliaryOfficeofDivision4 65000.00
Total Requests (including main    office): $ 1325000.00

注意，如前所述，可以使整个类成为另一个类的友元。Budget 类可以通过以下声明使 Aux 类成为友元：
friend class Aux;

但是，这可能并不是一个好主意，因为这将导致 Aux 的每个成员函数（包括稍后可能添加的函数）都可以访问 Budget 的私有成员。所以，最好的做法是只声明那些必须有权访问类的私有成员的函数作为友元。