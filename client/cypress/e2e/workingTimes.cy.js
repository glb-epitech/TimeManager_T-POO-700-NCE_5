describe('WorkingTimes', () => {
    beforeEach(() => {
      // Remplace `http://localhost:8080` par l'URL de ton application
      cy.visit('http://localhost:5173/workingTimes/2'); // Utilise un ID d'utilisateur valide
    });
  
    it('should display the correct title', () => {
      cy.contains('Working Times for User 2').should('be.visible'); // Change l'ID si nécessaire
    });
  
    it('should load working times', () => {
      cy.get('table').should('exist'); // Vérifie que la table existe
  
      // Vérifie que les données de la table sont affichées
      cy.get('tbody tr').should('have.length.greaterThan', 0); // Vérifie qu'il y a au moins une ligne
    });
  
    it('should display error message if no working times', () => {
      // Si tu as un scénario où il n'y a pas de temps de travail, tu peux tester cela
      cy.visit('http://localhost:5173/workingTimes/9999'); // Utilise un ID d'utilisateur qui n'a pas de temps de travail
      cy.contains('No working times available.').should('be.visible');
    });
  });
  