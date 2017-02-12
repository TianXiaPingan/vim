package rain;

import java.io.Serializable;
import java.util.*;
import org.apache.commons.lang3.ArrayUtils;
import org.apache.commons.lang3.StringUtils;
import static java.lang.System.out;

public class Alg {
  public static double EPSILON = 1e-8;

  public static class IntComparator implements Comparator<Integer>,
                                               Serializable {
    @Override
    public int compare(Integer m, Integer n) {
      return Integer.compare(m, n);
    }
  }

  public static Map<String, String> extractAttribute(String[] blocks) {
    Map<String, String> ret = new TreeMap<>();
    String[] tokens;
    for (String block: blocks) {
      if (!block.contains("=")) {
        out.println("found wrong block: " + block);
        return new TreeMap<>();
      }
      tokens = block.split("=");
      ret.put(tokens[0], tokens.length == 2 ? tokens[1] : "");
    }
    return ret;
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

  public static <Type> void resize(List<Type> list, int size, Type value) {
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
      out.println("Warning in l1Norm: 0 vector found");
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

  public static void main(String[] argv) {
    Timer timer = new Timer("Test Alg");
    out.println("Hello rain.Alg");

//    List<Integer> list = Arrays.asList(1, 2, 3, 4, 5);
//    out.println(Alg.front(list));
//    out.println(Alg.last(list));

    List<Double> data = new ArrayList<>();
    Alg.resize(data, 10, 0.);
    out.println(data.size());

    double[] weights = {
      1, 2, 3, 4, 
    };
    double[] weightsL1 = Alg.l1Norm(weights, 1.);
//    out.println(Alg.last(weights));

    out.println(Arrays.asList(ArrayUtils.toObject(weightsL1)));

    out.println(Alg.extractAttribute("name=\tage=30   ".split("\t")));
    
    timer.stop();
  }
};
