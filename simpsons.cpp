#include <iostream>
#include <functional>
#include <stdexcept>
#include <cmath>//power and exponentiation 
#include <memory>

// Forward declaration
class IntegrationStrategy;

// Integration Configuration Class
class IntegrationConfig {
private:
    double lowerLimit;
    double upperLimit;
    int subIntervals;

public:
    // Constructor with validation
    IntegrationConfig(double lower, double upper, int intervals) {
        if (lower >= upper) 
            throw std::invalid_argument("Lower limit must be less than upper limit");
        
        if (intervals <= 0 || intervals % 2 != 0) 
            throw std::invalid_argument("Number of sub-intervals must be a positive even number");

        lowerLimit = lower;
        upperLimit = upper;
        subIntervals = intervals;
    }

    // Getter methods
    double getLowerLimit() const { return lowerLimit; }
    double getUpperLimit() const { return upperLimit; }
    int getSubIntervals() const { return subIntervals; }
};

// Abstract Base Integration Strategy
class IntegrationStrategy {
public:
    virtual double integrate(const std::function<double(double)>& func, 
                             const IntegrationConfig& config) const = 0;
    virtual ~IntegrationStrategy() = default;
};

// Simpson's Rule Implementation
class SimpsonsRuleIntegration : public IntegrationStrategy {
public:
    double integrate(const std::function<double(double)>& func, 
                     const IntegrationConfig& config) const override {
        double lower = config.getLowerLimit();
        double upper = config.getUpperLimit();
        int subIntervals = config.getSubIntervals();

        double stepSize = (upper - lower) / subIntervals;
        double area = func(lower) + func(upper);

        for (int i = 1; i < subIntervals; i++) {
            double k = lower + i * stepSize;
            
            if (i % 2 == 0) {
                area += 2.0 * func(k);  // Even indices
            } else {
                area += 4.0 * func(k);  // Odd indices
            }
        }

        return area * stepSize / 3.0;
    }
};

// Integration Calculator (Facade)
class IntegrationCalculator {
private:
    std::unique_ptr<IntegrationStrategy> strategy;

public:
    IntegrationCalculator(std::unique_ptr<IntegrationStrategy> integrationMethod) 
        : strategy(std::move(integrationMethod)) {}

    double calculate(const std::function<double(double)>& func, 
                     double lowerLimit, 
                     double upperLimit, 
                     int subIntervals) {
        IntegrationConfig config(lowerLimit, upperLimit, subIntervals);
        return strategy->integrate(func, config);
    }
};

// Example Functions and Main Program
double exampleFunction1(double x) {
    return pow(x, 3.0) * exp(-x) / (x + 1.0);
}

double exampleFunction2(double x) {
    return 1.0 / x;  // 1/x integration
}

int main() {
    try {
        // Create integration strategy
        auto simpsonsRule = std::make_unique<SimpsonsRuleIntegration>();
        
        // Create integration calculator with Simpson's Rule
        IntegrationCalculator calculator(std::move(simpsonsRule));

        double lowerLimit, upperLimit;
        int subIntervals;

        std::cout << "Simpson's Rule Numerical Integration\n";
        std::cout << "------------------------------------\n";

        // Get integration parameters from user
        std::cout << "Enter lower limit (a): ";
        std::cin >> lowerLimit;

        std::cout << "Enter upper limit (b): ";
        std::cin >> upperLimit;

        std::cout << "Enter number of sub-intervals (must be even): ";
        std::cin >> subIntervals;

        // Option to choose function
        int functionChoice;
        std::cout << "Choose function to integrate:\n";
        std::cout << "1. f(x) = x³ * e^(-x) / (x+1)\n";
        std::cout << "2. f(x) = 1/x\n";
        std::cout << "Enter choice (1/2): ";
        std::cin >> functionChoice;

        double result;
        switch (functionChoice) {
            case 1:
                result = calculator.calculate(exampleFunction1, lowerLimit, upperLimit, subIntervals);
                break;
            case 2:
                result = calculator.calculate(exampleFunction2, lowerLimit, upperLimit, subIntervals);
                break;
            default:
                throw std::invalid_argument("Invalid function choice");
        }

        std::cout << "Numerical Integration Result: " << result << std::endl;
    }
    catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return 1;
    }

    return 0;
}