'use client'
import * as React from 'react';
import AppBar from '@mui/material/AppBar';
import Tabs from '@mui/material/Tabs';
import Tab from '@mui/material/Tab';
import Typography from '@mui/material/Typography';
import Box from '@mui/material/Box';
import TextField from '@mui/material/TextField';


interface TabPanelProps {
  children?: React.ReactNode;
  dir?: string;
  index: number;
  value: number;
}

function TabPanel(props: TabPanelProps) {
  const { children, value, index, ...other } = props;

  return (
    <div
      role="tabpanel"
      hidden={value !== index}
      id={`full-width-tabpanel-${index}`}
      aria-labelledby={`full-width-tab-${index}`}
      {...other}
    >
      {value === index && (
        <Box sx={{ p: 3 }}>
          {children}
        </Box>
      )}
    </div>
  );
}

function a11yProps(index: number) {
  return {
    id: `full-width-tab-${index}`,
    'aria-controls': `full-width-tabpanel-${index}`,
  };
}

const tabs = [
  {
    label: 'Gastos',
    value: 0,
  },
  {
    label: 'Ingresos',
    value: 1,
  },

];
export default function FullWidthTabs() {
  const [value, setValue] = React.useState(0);
  const [mounted, setMounted] = React.useState(false);

  React.useEffect(() => {
    setMounted(true);
  }, []);

  const handleChange = (event: React.SyntheticEvent, newValue: number) => {
    setValue(newValue);
  };

  if (!mounted) {
    return (
      <Box sx={{ bgcolor: 'background.paper', width: 500 }}>
        <AppBar position="static">
          <Tabs
            value={0}
            indicatorColor="secondary"
            textColor="inherit"
            variant="fullWidth"
            aria-label="full width tabs example"
          >
            {tabs.map((tab) => (
              <Tab key={tab.value} label={tab.label} {...a11yProps(tab.value)} />
            ))}
          </Tabs>
        </AppBar>
        <TabPanel value={0} index={0}>
          <div>
            <h1>Gastos</h1>
          </div>
        </TabPanel>
      </Box>
    );
  }

  return (
    <Box sx={{ bgcolor: 'background.paper', width: 500 }}>
      <AppBar position="static">
        <Tabs
          value={value}
          onChange={handleChange}
          indicatorColor="secondary"
          textColor="inherit"
          variant="fullWidth"
          aria-label="full width tabs example"
        >
          {tabs.map((tab) => (
            <Tab key={tab.value} label={tab.label} {...a11yProps(tab.value)} />
          ))}
        </Tabs>
      </AppBar>
      <TabPanel value={value} index={0}>
       
       <form className='flex flex-col items-center justify-center gap-y-4'>
       <TextField id="standard-basic" label="Nombre completo" variant="standard" name="name" className=' boder-b-[rgb(31,133,119)]' />
       <TextField id="standard-basic" label="Correo electrónico" variant="standard" type='email' name="email" />
       <TextField id="standard-basic" label="Contraseña" variant="standard" name="password" />
       <TextField id="standard-basic" label="Confirmar contraseña" variant="standard" name="confirmPassword" />
   

 </form>
      </TabPanel>
      <TabPanel value={value} index={1}>
       <form className='flex flex-col items-center justify-center gap-y-4'>
       <TextField id="standard-basic" label="Nombre completo" variant="standard" name="name" className=' boder-b-[rgb(31,133,119)]' />
       <TextField id="standard-basic" label="Correo electrónico" variant="standard" type='email' name="email" />
       <TextField id="standard-basic" label="Contraseña" variant="standard" name="password" />
       <TextField id="standard-basic" label="Confirmar contraseña" variant="standard" name="confirmPassword" />


 </form>
      </TabPanel>
     
    </Box>
  );
}