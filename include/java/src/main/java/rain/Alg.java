package rain;

import java.util.*;
import org.apache.commons.lang3.ArrayUtils;

public class Alg {
  public static Map<String, String> extractAttribute(String[] blocks) {
    Map<String, String> ret = new TreeMap<>();
    String[] tokens;
    for (String block: blocks) {
      tokens = block.split("=");
      if (tokens.length != 2) {
        System.out.println("found wrong block: " + block);
        continue;
      }

      ret.put(tokens[0].trim(), tokens[1].trim());
    }
    return ret;
  }

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

  public static double[] l1Norm(double[] weight, double norm) {
    double wsum = 0.;
    for (double w: weight) {
      wsum += Math.abs(w);
    }

    if (eq(wsum, 0)) {
      System.out.println("Warning in l1Norm: 0 vector found");
      return weight; 
    }

    double ratio = norm / wsum;
    double[] ret = new double[weight.length];
    for (int p = 0; p < weight.length; ++p) {
      ret[p] = weight[p] * ratio;
    }
    return ret;
  }

  //public static <Type> void update(List<Type> data, int pos, Type value) {
    //data.set(pos, data.get(pos) + value);
  //}

  public static double EPSILON = 1e-8;

  public static void main(String[] argv) {
    Timer timer = new Timer("Test Alg");
    System.out.println("Hello rain.Alg");

    List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
    System.out.println(Alg.front(list));
    System.out.println(Alg.last(list));

    List<Double> data = new ArrayList<>();
    Alg.reSize(data, 10, 0.);
    System.out.println(data.size());

    double[] weights = {
      1, 2, 3, 4, 
    };
    double[] weightsL1 = Alg.l1Norm(weights, 1.);

    System.out.println(Arrays.asList(ArrayUtils.toObject(weightsL1)));

    System.out.println(Alg.extractAttribute("name=summer\tage=30   ".split("\t")));
    
    timer.stop();
  }
};
