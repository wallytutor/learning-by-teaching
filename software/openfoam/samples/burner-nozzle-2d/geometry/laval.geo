// --------------------------------------------------------------------
// Laval nozzle geometry (as provided by Paul Bartkiewitz)
// 
// Author: Walter Dal'Maz Silva
// Date: Mar 08 2025
// --------------------------------------------------------------------

// SetFactory("OpenCASCADE");

General.BackgroundGradient = 0;
General.Color.Background = {200, 220, 240};
General.Color.Foreground = White;
General.Color.Text = White;
General.Color.Axes = White;
General.Color.SmallAxes = White;
General.Axes = 0;
General.SmallAxes = 1;
Geometry.OldNewReg = 0;

// --------------------------------------------------------------------
// Reference coordinates / dimensions
// --------------------------------------------------------------------

Include "points.geo";

// --------------------------------------------------------------------
// Lines
// --------------------------------------------------------------------

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};

Line(5) = {6, 7};
Line(6) = {7, 8};
Circle(7) = {8, 11, 9};
Line(8) = {9, 10};

Line(9) = {1, 6};
Line(10) = {5, 10};

// --------------------------------------------------------------------
// EOF
// --------------------------------------------------------------------
