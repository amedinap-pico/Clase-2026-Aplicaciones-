import unittest

from calculadora import dividir, multiplicar, promedio, restar, sumar


class PruebasCalculadora(unittest.TestCase):
    def test_sumar(self):
        self.assertEqual(sumar(2, 3), 5)

    def test_restar(self):
        self.assertEqual(restar(5, 3), 2)

    def test_multiplicar(self):
        self.assertEqual(multiplicar(4, 3), 12)

    def test_dividir(self):
        self.assertEqual(dividir(10, 4), 2.5)
        with self.assertRaises(ValueError):
            dividir(1, 0)

    def test_promedio(self):
        self.assertEqual(promedio([2, 4, 6]), 4)


if __name__ == "__main__":
    unittest.main()
