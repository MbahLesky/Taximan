const statusBar = document.getElementById('statusBar');
const totalUsers = document.getElementById('totalUsers');
const totalDrivers = document.getElementById('totalDrivers');
const pendingDrivers = document.getElementById('pendingDrivers');
const driverList = document.getElementById('driverList');
const userList = document.getElementById('userList');
const driverSearch = document.getElementById('driverSearch');
const userSearch = document.getElementById('userSearch');
const driversTabBtn = document.querySelector('[data-tab="driversTab"]');
const usersTabBtn = document.querySelector('[data-tab="usersTab"]');
const driversTab = document.getElementById('driversTab');
const usersTab = document.getElementById('usersTab');
const driverDetails = document.getElementById('driverDetails');
const emptyState = document.getElementById('emptyState');
const driverName = document.getElementById('driverName');
const driverStatus = document.getElementById('driverStatus');
const driverIdLabel = document.getElementById('driverIdLabel');
const driverEmail = document.getElementById('driverEmail');
const driverPhone = document.getElementById('driverPhone');
const driverCity = document.getElementById('driverCity');
const driverAvailability = document.getElementById('driverAvailability');
const driverVerification = document.getElementById('driverVerification');
const driverCreated = document.getElementById('driverCreated');
const documentList = document.getElementById('documentList');
const driverAction = document.getElementById('driverAction');
const approveDriverBtn = document.getElementById('approveDriverBtn');
const rejectDriverBtn = document.getElementById('rejectDriverBtn');

const firebaseConfig = {
  apiKey: 'AIzaSyAHM5DK9xsWmRkzgHEjqyw6aP11qRLovDo',
  authDomain: 'taximan-835d2.firebaseapp.com',
  projectId: 'taximan-835d2',
  storageBucket: 'taximan-835d2.firebasestorage.app',
  messagingSenderId: '385844694654',
  appId: '1:385844694654:web:712a2c57326a96b84b522f',
  measurementId: 'G-F50FHHCB5Q',
};

let state = {
  drivers: [],
  users: [],
  documents: [],
  selectedDriver: null,
  db: null,
};

function setStatus(message, type = 'normal') {
  statusBar.textContent = message;
  statusBar.style.color = type === 'error' ? '#b91c1c' : '#334155';
}

async function initFirestore() {
  const { initializeApp } = await import('https://www.gstatic.com/firebasejs/12.14.0/firebase-app.js');
  const { getFirestore } = await import('https://www.gstatic.com/firebasejs/12.14.0/firebase-firestore.js');

  const app = initializeApp(firebaseConfig);
  state.db = getFirestore(app);
}

async function fetchDrivers() {
  const { collection, getDocs, orderBy, query } = await import('https://www.gstatic.com/firebasejs/12.14.0/firebase-firestore.js');
  const driversRef = collection(state.db, 'drivers');
  const q = query(driversRef, orderBy('fullName'));
  const snapshot = await getDocs(q);
  state.drivers = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
}

async function fetchUsers() {
  const { collection, getDocs, orderBy, query } = await import('https://www.gstatic.com/firebasejs/12.14.0/firebase-firestore.js');
  const usersRef = collection(state.db, 'users');
  const q = query(usersRef, orderBy('fullName'));
  const snapshot = await getDocs(q);
  state.users = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
}

async function fetchDriverDocuments(driverId) {
  const { collection, getDocs, query, where, orderBy } = await import('https://www.gstatic.com/firebasejs/12.14.0/firebase-firestore.js');
  const docsRef = collection(state.db, 'driver_documents');
  const q = query(docsRef, where('driverId', '==', driverId), orderBy('documentType'));
  const snapshot = await getDocs(q);
  state.documents = snapshot.docs.map((doc) => ({ id: doc.id, ...doc.data() }));
}

function refreshSummary() {
  const userCount = state.users.length;
  const driverCount = state.drivers.length;
  const pendingCount = state.drivers.filter((driver) => driver.verificationStatus?.toLowerCase() === 'pending').length;

  totalUsers.textContent = userCount;
  totalDrivers.textContent = driverCount;
  pendingDrivers.textContent = pendingCount;
}

function renderDriverList() {
  const searchValue = driverSearch.value.trim().toLowerCase();
  const drivers = state.drivers.filter((driver) => {
    const text = [driver.fullName, driver.email, driver.phone, driver.city, driver.verificationStatus].join(' ').toLowerCase();
    return text.includes(searchValue);
  });

  if (drivers.length === 0) {
    driverList.innerHTML = '<div class="list-item"><strong>No drivers found</strong><small>Try a broader search term.</small></div>';
    return;
  }

  driverList.innerHTML = drivers
    .map((driver) => {
      const pending = driver.verificationStatus?.toLowerCase() === 'pending';
      const badge = pending ? '<span class="status-pill">Pending</span>' : `<span class="status-pill">${driver.verificationStatus?.replace(/^[a-z]/, (m) => m.toUpperCase())}</span>`;
      const selectedClass = state.selectedDriver?.id === driver.id ? ' selected' : '';
      return `
        <button class="list-item${selectedClass}" data-driver-id="${driver.id}">
          <strong>${driver.fullName}</strong>
          <small>${driver.email || 'No email provided'}</small>
          <div>${badge}</div>
        </button>
      `;
    })
    .join('');

  driverList.querySelectorAll('[data-driver-id]').forEach((button) => {
    button.addEventListener('click', () => selectDriver(button.dataset.driverId));
  });
}

function renderUserList() {
  const searchValue = userSearch.value.trim().toLowerCase();
  const users = state.users.filter((user) => {
    const text = [user.fullName, user.email, user.role].join(' ').toLowerCase();
    return text.includes(searchValue);
  });

  if (users.length === 0) {
    userList.innerHTML = '<div class="list-item"><strong>No users found</strong><small>Try a broader search term.</small></div>';
    return;
  }

  userList.innerHTML = users
    .map((user) => {
      return `
        <div class="list-item">
          <strong>${user.fullName}</strong>
          <small>${user.email || 'No email'}</small>
          <small>Role: ${user.role || 'passenger'}</small>
        </div>
      `;
    })
    .join('');
}

function renderDriverDetails() {
  if (!state.selectedDriver) {
    driverDetails.classList.add('hidden');
    emptyState.classList.remove('hidden');
    return;
  }

  const driver = state.selectedDriver;
  emptyState.classList.add('hidden');
  driverDetails.classList.remove('hidden');

  driverName.textContent = driver.fullName || 'Unnamed driver';
  driverStatus.textContent = driver.verificationStatus ? driver.verificationStatus.replace(/^[a-z]/, (m) => m.toUpperCase()) : 'Unknown';
  driverIdLabel.textContent = `ID: ${driver.id}`;
  driverEmail.textContent = driver.email || '—';
  driverPhone.textContent = driver.phone || '—';
  driverCity.textContent = driver.city || '—';
  driverAvailability.textContent = driver.availabilityStatus || 'offline';
  driverVerification.textContent = driver.verificationStatus || 'pending';
  driverCreated.textContent = formatCreatedAt(driver.createdAt);

  renderDocuments();
}

function renderDocuments() {
  if (!state.documents.length) {
    documentList.innerHTML = '<div class="document-card"><strong>No documents found</strong><span>This driver has not uploaded any documents yet.</span></div>';
    driverAction.classList.add('hidden');
    return;
  }

  documentList.innerHTML = state.documents
    .map((document) => {
      const statusLabel = document.status?.toLowerCase() === 'approved' ? 'Approved' : document.status?.toLowerCase() === 'rejected' ? 'Rejected' : 'Pending';
      const statusClass = document.status?.toLowerCase() === 'approved' ? 'status-pill' : document.status?.toLowerCase() === 'rejected' ? 'status-pill danger' : 'status-pill';
      return `
        <article class="document-card">
          <header>
            <div>
              <strong>${document.documentType.replace(/_/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase())}</strong>
              <span>${statusLabel}</span>
            </div>
            <span class="${statusClass}">${statusLabel}</span>
          </header>
          <div class="doc-meta">
            <span><strong>Document ID:</strong> ${document.id}</span>
            <span><strong>File URL:</strong> <a href="${document.fileUrl}" target="_blank">View file</a></span>
            ${document.rejectionReason ? `<span><strong>Rejection reason:</strong> ${document.rejectionReason}</span>` : ''}
          </div>
          <div class="doc-actions">
            <button class="primary" data-action="approve" data-doc-id="${document.id}">Approve</button>
            <button class="danger" data-action="reject" data-doc-id="${document.id}">Reject</button>
          </div>
        </article>
      `;
    })
    .join('');

  documentList.querySelectorAll('[data-action]').forEach((button) => {
    button.addEventListener('click', async () => {
      const docId = button.dataset.docId;
      const action = button.dataset.action;
      await updateDocumentStatus(docId, action === 'approve' ? 'approved' : 'rejected');
    });
  });

  const allReviewed = state.documents.every((doc) => doc.status?.toLowerCase() !== 'pending');
  const allApproved = allReviewed && state.documents.every((doc) => doc.status?.toLowerCase() === 'approved');
  const allRejected = allReviewed && state.documents.every((doc) => doc.status?.toLowerCase() === 'rejected');

  approveDriverBtn.style.display = allApproved ? 'inline-flex' : 'none';
  rejectDriverBtn.style.display = allRejected ? 'inline-flex' : 'none';
  driverAction.classList.toggle('hidden', !allReviewed);
}

async function selectDriver(driverId) {
  // set selected driver immediately so the UI can react
  state.selectedDriver = state.drivers.find((driver) => driver.id === driverId) || null;
  console.log('Driver selected:', driverId, state.selectedDriver);
  setStatus(`Selected driver ${driverId}`);
  try {
    // attempt to load documents; do not block rendering of driver details on failure
    await fetchDriverDocuments(driverId);
  } catch (err) {
    console.error('Failed to fetch documents for driver', driverId, err);
    setStatus(`Warning: could not load documents for driver ${driverId}`, 'error');
    // ensure we have an empty documents list so renderDocuments can run
    state.documents = [];
  }

  // render details and refresh list selection highlight
  renderDriverDetails();
  renderDriverList();
}

async function updateDocumentStatus(documentId, status) {
  const document = state.documents.find((doc) => doc.id === documentId);
  if (!document) {
    setStatus('Document not found in current driver details.', 'error');
    return;
  }

  try {
    const { doc, updateDoc, serverTimestamp } = await import('https://www.gstatic.com/firebasejs/12.14.0/firebase-firestore.js');
    const documentRef = doc(state.db, 'driver_documents', documentId);
    await updateDoc(documentRef, {
      status,
      rejectionReason: status === 'rejected' ? 'Rejected by admin' : null,
      reviewedAt: serverTimestamp(),
    });

    await fetchDriverDocuments(state.selectedDriver.id);
    renderDocuments();
    setStatus(`Document ${document.documentType} updated to ${status}.`);
  } catch (error) {
    console.error(error);
    setStatus(`Failed to update document status: ${error.message}`, 'error');
  }
}

async function updateDriverStatus(status) {
  if (!state.selectedDriver) {
    return;
  }

  try {
    const { doc, updateDoc, serverTimestamp } = await import('https://www.gstatic.com/firebasejs/12.14.0/firebase-firestore.js');
    const driverRef = doc(state.db, 'drivers', state.selectedDriver.id);
    await updateDoc(driverRef, {
      verificationStatus: status,
      updatedAt: serverTimestamp(),
    });

    await fetchDrivers();
    state.selectedDriver = state.drivers.find((driver) => driver.id === state.selectedDriver.id) || state.selectedDriver;
    refreshSummary();
    renderDriverDetails();
    renderDriverList();
    setStatus(`Driver ${status} successfully.`);
  } catch (error) {
    console.error(error);
    setStatus(`Failed to update driver status: ${error.message}`, 'error');
  }
}

function formatCreatedAt(createdAt) {
  if (!createdAt) return '—';
  const date = new Date(createdAt.seconds ? createdAt.seconds * 1000 : createdAt);
  return date.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' });
}

function bindUiEvents() {
  driverSearch.addEventListener('input', renderDriverList);
  userSearch.addEventListener('input', renderUserList);

  driversTabBtn.addEventListener('click', () => {
    driversTabBtn.classList.add('active');
    usersTabBtn.classList.remove('active');
    driversTab.classList.remove('hidden');
    usersTab.classList.add('hidden');
  });

  usersTabBtn.addEventListener('click', () => {
    usersTabBtn.classList.add('active');
    driversTabBtn.classList.remove('active');
    usersTab.classList.remove('hidden');
    driversTab.classList.add('hidden');
  });

  approveDriverBtn.addEventListener('click', async () => updateDriverStatus('approved'));
  rejectDriverBtn.addEventListener('click', async () => updateDriverStatus('rejected'));
}

async function refreshAllData() {
  await fetchUsers();
  await fetchDrivers();
  refreshSummary();
  renderUserList();
  renderDriverList();
  if (state.selectedDriver) {
    state.selectedDriver = state.drivers.find((driver) => driver.id === state.selectedDriver.id) || state.selectedDriver;
    if (state.selectedDriver) {
      await fetchDriverDocuments(state.selectedDriver.id);
      renderDriverDetails();
    }
  }
}

window.addEventListener('DOMContentLoaded', async () => {
  bindUiEvents();
  try {
    setStatus('Connecting to Firestore...');
    await initFirestore();
    await refreshAllData();
    setStatus('Connected to Firestore.');
  } catch (error) {
    console.error(error);
    setStatus(`Failed to connect to Firestore: ${error.message}`, 'error');
  }
});
