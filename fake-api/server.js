// fake-api/server.js

const express = require('express');
const cors    = require('cors');
const app     = express();
const PORT    = 3000;

app.use(cors());
app.use(express.json());

// ————— In‐memory DB —————

// Developers (para seleccionar al crear contrato)
let developers = [
  {
    id: '1',
    name: 'Juan Carlos Carbajal',
    contracts: 3,
    rating: 5,
    photoUrl:
      'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  },
  {
    id: '2',
    name: 'José Antonio Ramírez Soto',
    contracts: 3,
    rating: 4,
    photoUrl: 'https://images.pexels.com/photos/10402659/pexels-photo-10402659.jpeg'
  },
  {
    id: '3',
    name: 'María Fernanda López Castillo',
    contracts: 3,
    rating: 5,
    photoUrl:
      'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=688&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  },
];

// Función auxiliar para buscar developer y evitar undefined
const findDev = (id) => developers.find((d) => d.id === id) || { name: '', photoUrl: '' };

// ————— Contracts + incrementador de ID —————
let contracts = [
  {
    id: '1',
    developerId:       '1',
    developerName:     findDev('1').name,
    developerPhotoUrl: findDev('1').photoUrl,
    createdAt:         '2025-06-10T00:00:00.000Z',
    projectTitle:      'Contrato Activo',
    projectDescription:'Proyecto con hitos activos',
    status:            'active',  // active | pending | completed | cancelled
    milestones: [
      { id:'1-1', description:'Diseño de interfaz',    amount:150, deadline:'2025-07-01T00:00:00.000Z' },
      { id:'1-2', description:'Implementación backend', amount:300, deadline:'2025-07-15T00:00:00.000Z' },
      { id:'1-3', description:'Pruebas y despliegue',   amount:100, deadline:'2025-08-01T00:00:00.000Z' }
    ],
  },
  {
    id: '2',
    developerId:       '2',
    developerName:     findDev('2').name,
    developerPhotoUrl: findDev('2').photoUrl,
    createdAt:         '2025-06-04T00:00:00.000Z',
    projectTitle:      'Contrato Pendiente',
    projectDescription:'Proyecto aún no iniciado',
    status:            'pending',
    milestones: [
      { id:'2-1', description:'Recolección de requisitos', amount:200, deadline:'2025-08-01T00:00:00.000Z' },
      { id:'2-2', description:'Diseño técnico',            amount:250, deadline:'2025-08-15T00:00:00.000Z' },
      { id:'2-3', description:'Desarrollo inicial',        amount:300, deadline:'2025-09-01T00:00:00.000Z' }
    ],
  },
  {
    id: '3',
    developerId:       '3',
    developerName:     findDev('3').name,
    developerPhotoUrl: findDev('3').photoUrl,
    createdAt:         '2025-01-05T00:00:00.000Z',
    projectTitle:      'Contrato Cancelado',
    projectDescription:'Proyecto cancelado',
    status:            'cancelled',
    milestones: [
      { id:'3-1', description:'Planificación',     amount:100, deadline:'2025-06-01T00:00:00.000Z' },
      { id:'3-2', description:'Desarrollo',         amount:200, deadline:'2025-06-15T00:00:00.000Z' },
      { id:'3-3', description:'Cierre de proyecto', amount:150, deadline:'2025-06-30T00:00:00.000Z' }
    ],
  },
];
let nextContractId = 4;

// ————— Datos de firma por contrato —————
let signatures = {
  '1': {
    hash:       '0xA1B2C3D4E5F6',
    network:    'Ethereum Rinkeby',
    executedAt: '2025-06-16T14:32:00.000Z',
    signedBy: [
      { role:'cliente', name:'Ana López' },
      { role:'dev',     name:'Pedro Pérez' }
    ],
  },
  '2': { hash:'', network:'', executedAt:'', signedBy:[] },
  '3': { hash:'', network:'', executedAt:'', signedBy:[] }
};

// ————— Estado (próximo hito) por contrato —————
let statuses = {
  '1': {
    description: 'Implementación backend',
    deadline:    '2025-07-15',
    amount:      300,
    status:      'active'
  },
  '2': {
    description: 'Recolección de requisitos',
    deadline:    '2025-08-01',
    amount:      200,
    status:      'pending'
  },
  '3': {
    description: 'Planificación',
    deadline:    '2025-06-01',
    amount:      100,
    status:      'cancelled'
  }
};

// ————— Profile único —————
let userProfile = {
  name:  'Juan Pérez',
  email: 'juan@ejemplo.com',
  phone: '555-1234'
};

// ————— Rutas —————
// Auth
app.post('/auth/login', (req, res) => {
  const { email, password } = req.body;
  if (email && password) {
    return res.status(200).json({ token: 'fake-jwt-token' });
  }
  return res.status(400).json({ error: true, message: 'Credenciales inválidas' });
});
app.post('/auth/signup', (req, res) => {
  const { name, email, password } = req.body;
  if (name && email && password) {
    return res.status(201).json({ message: 'Usuario registrado correctamente' });
  }
  return res.status(400).json({ error: true, message: 'Datos incompletos' });
});

// Profile
app.get('/profile', (_req, res) => {
  res.json({ data: userProfile });
});
app.put('/profile', (req, res) => {
  const { name, email, phone } = req.body;
  userProfile = { name, email, phone };
  res.json({ message:'Perfil actualizado', data: userProfile });
});

// Developers
app.get('/developers', (_req, res) => {
  res.json({ data: developers });
});

// Contracts
app.get('/contracts', (_req, res) => {
  res.json({ data: contracts });
});
app.post('/contracts', (req, res) => {
  const { developerId, projectTitle, projectDescription, status, milestones } = req.body;
  const dev = findDev(developerId);
  const newContract = {
    id:                String(nextContractId++),
    developerId,
    developerName:     dev.name,
    developerPhotoUrl: dev.photoUrl,
    createdAt:         new Date().toISOString(),
    projectTitle,
    projectDescription,
    status,
    milestones
  };
  contracts.push(newContract);
  signatures[newContract.id] = { hash:'', network:'', executedAt:'', signedBy:[] };
  statuses[newContract.id]   = { description:'', deadline:'', amount:0, status:'pending' };
  res.status(201).json({ data: newContract });
});
app.get('/contracts/:id', (req, res) => {
  const c = contracts.find(x => x.id === req.params.id);
  return c
    ? res.json({ data: c })
    : res.status(404).json({ error:true, message:'Contrato no encontrado' });
});
app.post('/contracts/:id/sign', (req, res) => {
  const c = contracts.find(x => x.id === req.params.id);
  if (!c) return res.status(404).json({ error:true, message:'Contrato no encontrado' });
  c.status = 'active';
  signatures[c.id] = {
    hash:       '0x'+Math.random().toString(16).slice(2),
    network:    'Ethereum Rinkeby',
    executedAt: new Date().toISOString(),
    signedBy: [
      { role:'cliente', name:'Juan Pérez' },
      { role:'dev',     name:'Mock Dev' }
    ]
  };
  return res.json({ message:'Contrato firmado correctamente' });
});

// Delivery (hitos entregados)
app.get('/contracts/:id/delivery', (req, res) => {
  const c = contracts.find(x => x.id === req.params.id);
  if (!c) return res.status(404).json({ error:true, message:'Contrato no encontrado' });
  return res.json({ data: c.milestones });
});

// Signature endpoint
app.get('/contracts/:id/signature', (req, res) => {
  const sig = signatures[req.params.id];
  return sig
    ? res.json({ data: sig })
    : res.status(404).json({ error:true, message:'Firma no encontrada' });
});

// Status endpoint
app.get('/contracts/:id/status', (req, res) => {
  const st = statuses[req.params.id];
  return st
    ? res.json({ data: st })
    : res.status(404).json({ error:true, message:'Estado no encontrado' });
});

// ————— Levantar servidor —————
app.listen(PORT, () => {
  console.log(`Fake API corriendo en http://localhost:${PORT}`);
});
