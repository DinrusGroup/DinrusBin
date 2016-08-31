/***************************************************************
                          inline/system.inl
 ***************************************************************/

module derelict.allegro.inline.system_inl;

import derelict.allegro.system;


void set_window_title(in char *name)
{
   assert(system_driver);

   if (system_driver.set_window_title)
      system_driver.set_window_title(name);
}


int desktop_color_depth()
{
   assert(system_driver);

   if (system_driver.desktop_color_depth)
      return system_driver.desktop_color_depth();
   else
      return 0;
}


int get_desktop_resolution(int *width, int *height)
{
   assert(system_driver);

   if (system_driver.get_desktop_resolution)
      return system_driver.get_desktop_resolution(width, height);
   else
      return -1;
}
