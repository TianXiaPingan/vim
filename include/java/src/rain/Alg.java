package rain;

import java.util.*;

public class Alg {
  public static <Type> void reverse(Type[] data, int f, int t) {
    while (f < t - 1) {
      Type v = data[f];
      data[f++] = data[t - 1];
      data[t-- - 1] = v;
    }
  }

  public static boolean eq(double a, double b) {
    return Math.abs(a - b) <= EPSILON;
  }

  public static boolean strictLess(double a, double b) {
    return !eq(a, b) && a < b;
  }

  public static boolean strictGreater(double a, double b) {
    return !eq(a, b) && a > b;
  }

  public static <Type> Type front(List<Type> list) {
    return list != null && !list.isEmpty() ? list.get(0) : null;
  }

  public static <Type> Type last(List<Type> list) {
    return list != null && !list.isEmpty() ? list.get(list.size() - 1) : null;
  }

  public static <Type> void reSize(List<Type> list, int size, Type value) {
    while (list.size() < size) {
      list.add(value);
    }
    while (list.size() > size) {
      list.remove(list.size() - 1);
    }
  }

  public static double EPSILON = 1e-6;

  public static void main(String[] argv) {
    System.out.println("Hello rain.Alg");

    List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
    System.out.println(Alg.front(list));
    System.out.println(Alg.last(list));

    List<Double> data = new ArrayList<>();
    Alg.reSize(data, 10, 0.);
    System.out.println(data.size());
  }
};
